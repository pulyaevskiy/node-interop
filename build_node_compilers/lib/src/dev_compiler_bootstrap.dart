// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_modules/build_modules.dart';
import 'package:path/path.dart' as _p;
import 'package:pool/pool.dart';

import 'ddc_names.dart';
import 'dev_compiler_builder.dart';
import 'node_entrypoint_builder.dart';
import 'platforms.dart';

/// Alias `_p.url` to `p`.
_p.Context get _context => _p.url;

Future<void> bootstrapDdc(BuildStep buildStep,
    {DartPlatform? platform,
    Set<String> skipPlatformCheckPackages = const {}}) async {
  var dartEntrypointId = buildStep.inputId;
  var moduleId = buildStep.inputId
      .changeExtension(moduleExtension(platform ?? ddcPlatform));
  var module = Module.fromJson(json
      .decode(await buildStep.readAsString(moduleId)) as Map<String, dynamic>);

  // First, ensure all transitive modules are built.
  List<AssetId> transitiveJsModules;
  try {
    transitiveJsModules = await _ensureTransitiveJsModules(module, buildStep,
        skipPlatformCheckPackages: skipPlatformCheckPackages);
  } on UnsupportedModules catch (e) {
    var librariesString = (await e.exactLibraries(buildStep).toList())
        .map((lib) => AssetId(lib.id.package,
            lib.id.path.replaceFirst(moduleLibraryExtension, '.dart')))
        .join('\n');
    log.warning('''
Skipping compiling ${buildStep.inputId} with ddc because some of its
transitive libraries have sdk dependencies that not supported on this platform:

$librariesString

https://github.com/dart-lang/build/blob/master/docs/faq.md#how-can-i-resolve-skipped-compiling-warnings
''');
    return;
  }

  var jsId = module.primarySource.changeExtension(jsModuleExtension);
  var appModuleName = ddcModuleName(jsId);
  var appDigestsOutput =
      dartEntrypointId.changeExtension(digestsEntrypointExtension);

  // Package-relative entrypoint name within the entrypoint JS module.
  var appModuleScope =
      pathToJSIdentifier(_context.withoutExtension(buildStep.inputId.path));

  // Map from module name to module path for custom modules.
  var modulePaths = SplayTreeMap.of(
      {'dart_sdk': r'packages/$sdk/dev_compiler/common/dart_sdk'});

  for (var jsId in transitiveJsModules) {
    // Strip out the top level dir from the path for any module, and set it to
    // `packages/` for lib modules. We set baseUrl to `/` to simplify things,
    // and we only allow you to serve top level directories.
    var moduleName = ddcModuleName(jsId);
    modulePaths[moduleName] = _context.withoutExtension(
        jsId.path.startsWith('lib')
            ? '$moduleName$jsModuleExtension'
            : _context.joinAll(_context.split(jsId.path).skip(1)));
  }

  var bootstrapId = dartEntrypointId.changeExtension(ddcBootstrapExtension);
  var bootstrapModuleName = _context.withoutExtension(_context.relative(
      bootstrapId.path,
      from: _context.dirname(dartEntrypointId.path)));

  var bootstrapContent = StringBuffer();
  bootstrapContent.write(_dartLoaderSetup(modulePaths));
  bootstrapContent.write(_appBootstrap(appModuleName, appModuleScope));

  await buildStep.writeAsString(bootstrapId, bootstrapContent.toString());

  var entrypointJsContent = _entryPointJs(bootstrapModuleName);
  await buildStep.writeAsString(
      dartEntrypointId.changeExtension(jsEntrypointExtension),
      entrypointJsContent);

  // Output the digests for transitive modules.
  // These can be consumed for hot reloads.
  var moduleDigests = <String, String>{
    for (var jsId in transitiveJsModules)
      _moduleDigestKey(jsId): '${await buildStep.digest(jsId)}',
  };
  await buildStep.writeAsString(appDigestsOutput, jsonEncode(moduleDigests));

  await buildStep.writeAsString(
      dartEntrypointId.changeExtension(jsEntrypointSourceMapExtension),
      '{"version":3,"sourceRoot":"","sources":[],"names":[],"mappings":"",'
      '"file":""}');
}

String _moduleDigestKey(AssetId jsId) =>
    '${ddcModuleName(jsId)}$jsModuleExtension';

final _lazyBuildPool = Pool(16);

/// Ensures that all transitive js modules for [module] are available and built.
///
/// Throws an [UnsupportedModules] exception if there are any
/// unsupported modules.
Future<List<AssetId>> _ensureTransitiveJsModules(
    Module module, BuildStep buildStep,
    {Set<String>? skipPlatformCheckPackages}) async {
  // Collect all the modules this module depends on, plus this module.
  var transitiveDeps = await module.computeTransitiveDependencies(buildStep);

  var jsModules = [
    module.primarySource.changeExtension(jsModuleExtension),
    for (var dep in transitiveDeps)
      dep.primarySource.changeExtension(jsModuleExtension),
  ];
  // Check that each module is readable, and warn otherwise.
  await Future.wait(jsModules.map((jsId) async {
    if (await _lazyBuildPool.withResource(() => buildStep.canRead(jsId))) {
      return;
    }
    var errorsId = jsId.addExtension('.errors');
    await buildStep.canRead(errorsId);
    log.warning('Unable to read $jsId, check your console or the '
        '`.dart_tool/build/generated/${errorsId.package}/${errorsId.path}` '
        'log file.');
  }));
  return jsModules;
}

/// Code that actually imports the [moduleName] module, and calls the
/// `[moduleScope].main()` function on it.
///
/// Also performs other necessary initialization.
String _appBootstrap(String moduleName, String moduleScope) => '''
const app = require("$moduleName");
dart_sdk._isolate_helper.startRootIsolate(() => {}, []);
// Register main app function in the bootstrap exports so that it can be
// invoked by the entry point JS module.
module.exports.main = app.$moduleScope.main;
''';

/// The actual entrypoint JS file which injects all the necessary scripts to
/// run the app.
String _entryPointJs(String bootstrapModuleName) => '''
const bootstrap = require("./$bootstrapModuleName");
// Set this module's exports to the exports object of bootstrap module.
module.exports = bootstrap;
// Run the app which can (optionally) register more exports.
bootstrap.main();
''';

/// Sets up a proxy for Node's `require` which can resolve Dart modules
/// from [modulePaths].
String _dartLoaderSetup(Map<String, String> modulePaths) => '''
let modulePaths = ${const JsonEncoder.withIndent(" ").convert(modulePaths)};

const path = require('path');
const process = require('process');

/// Resolves module [id] for Dart package names to their absolute filenames.
/// Regular NodeJS module IDs are returned as-is.
function resolveId(id) {
  if (id in modulePaths) {
    var parts = process.argv[1].split(path.sep).slice(0,-1);
    parts.push(modulePaths[id]);
    var newId = parts.join(path.sep);
    return newId;
  }
  return id;
};

// Override built-in `Module.require` function to resolve Dart package
// names to their absolute filename paths.
var Module = require('module');
var moduleRequire = Module.prototype.require;
Module.prototype.require = function () {
  var id = arguments['0'];
  arguments['0'] = resolveId(id);
  return moduleRequire.apply(this, arguments);
};
// From this point each call to `require` will be able to resolve Dart package
// names.

const dart_sdk = require("dart_sdk");
const dart = dart_sdk.dart;

// There is a JS binding for `require` function in `node_interop` package.
// DDC treats this binding as global and maps all calls to this function
// in Dart code to `dart.global.require`. We define this function here as a 
// proxy to require function of bootstrap module.
dart.global.require = function (id) {
  return require(id);
};

// We also expose this module's exports here so that main Dart module
// can register its functionality to be exported.
// This exports object is forwarded by the entry point JS module.
dart.global.exports = module.exports;

// Some browser-specific globals which dart_sdk.js expects to be defined.
dart.global.Blob = function () { };
dart.global.Event = function () { };
dart.global.window = function () { };
dart.global.Window = function () { };
dart.global.ImageData = function () { };
dart.global.Node = function () { };
// TODO: this is better to use __filename of the main.dart.js file
dart.global.self = {
    location: { href: __filename }
};
''';
