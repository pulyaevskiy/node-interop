// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_modules/build_modules.dart';
import 'package:path/path.dart' as _p; // ignore: library_prefixes

import 'dev_compiler_builder.dart';
import 'node_entrypoint_builder.dart';

/// Alias `_p.url` to `p`.
_p.Context get p => _p.url;

Future<Null> bootstrapDdc(BuildStep buildStep,
    {bool useKernel, bool buildRootAppSummary}) async {
  useKernel ??= false;
  buildRootAppSummary ??= false;
  var dartEntrypointId = buildStep.inputId;
  var moduleId = buildStep.inputId.changeExtension(moduleExtension);
  var module = new Module.fromJson(json
      .decode(await buildStep.readAsString(moduleId)) as Map<String, dynamic>);

  if (buildRootAppSummary) await buildStep.canRead(module.linkedSummaryId);

  // First, ensure all transitive modules are built.
  var transitiveDeps = await _ensureTransitiveModules(module, buildStep);
  var jsId = module.jsId(jsModuleExtension);
  var appModuleName = _ddcModuleName(jsId);

  // The name of the entrypoint dart library within the entrypoint JS module.
  //
  // This is used to invoke `main()` from within the bootstrap script.
  //
  // TODO(jakemac53): Sane module name creation, this only works in the most
  // basic of cases.
  //
  // See https://github.com/dart-lang/sdk/issues/27262 for the root issue
  // which will allow us to not rely on the naming schemes that dartdevc uses
  // internally, but instead specify our own.
  var appModuleScope = () {
    if (useKernel) {
      var basename = p.basename(jsId.path);
      return basename.substring(0, basename.length - jsModuleExtension.length);
    } else {
      return p.split(_ddcModuleName(jsId)).skip(1).join('__');
    }
  }();
  appModuleScope = appModuleScope.replaceAll('.', '\$46');

  // Map from module name to module path for custom modules.
  Map<String, String> modulePaths = {
    'dart_sdk': 'packages/\$sdk/dev_compiler/common/dart_sdk',
  };
  List<AssetId> transitiveJsModules = [jsId]
    ..addAll(transitiveDeps.map((dep) => dep.jsId(jsModuleExtension)));
  for (var transJsId in transitiveJsModules) {
    // Strip out the top level dir from the path for any module, and set it to
    // `packages/` for lib modules. We set baseUrl to `/` to simplify things,
    // and we only allow you to serve top level directories.
    String moduleName = _ddcModuleName(transJsId);
    modulePaths[moduleName] = p.withoutExtension(
        transJsId.path.startsWith('lib')
            ? '$moduleName$jsModuleExtension'
            : p.joinAll(p.split(transJsId.path).skip(1)));
  }

  var bootstrapContent = new StringBuffer();
  bootstrapContent.write(_dartLoaderSetup(modulePaths));
  bootstrapContent.write(_appBootstrap(appModuleName, appModuleScope));

  var bootstrapId = dartEntrypointId.changeExtension(ddcBootstrapExtension);
  await buildStep.writeAsString(bootstrapId, bootstrapContent.toString());

  var bootstrapModuleName = p.withoutExtension(
      p.relative(bootstrapId.path, from: p.dirname(dartEntrypointId.path)));

  var entrypointJsContent = _entryPointJs(bootstrapModuleName);
  await buildStep.writeAsString(
      dartEntrypointId.changeExtension(jsEntrypointExtension),
      entrypointJsContent);
  await buildStep.writeAsString(
      dartEntrypointId.changeExtension(jsEntrypointSourceMapExtension),
      '{"version":3,"sourceRoot":"","sources":[],"names":[],"mappings":"",'
      '"file":""}');
}

/// Ensures that all transitive js modules for [module] are available and built.
Future<List<Module>> _ensureTransitiveModules(
    Module module, AssetReader reader) async {
  // Collect all the modules this module depends on, plus this module.
  var transitiveDeps = await module.computeTransitiveDependencies(reader);
  List<AssetId> jsModules = transitiveDeps
      .map((module) => module.jsId(jsModuleExtension))
      .toList()
        ..add(module.jsId(jsModuleExtension));
  // Check that each module is readable, and warn otherwise.
  await Future.wait(jsModules.map((jsId) async {
    if (await reader.canRead(jsId)) return;
    log.warning(
        'Unable to read $jsId, check your console for compilation errors.');
  }));
  return transitiveDeps;
}

/// The module name according to ddc for [jsId] which represents the real js
/// module file.
String _ddcModuleName(AssetId jsId) {
  var jsPath = jsId.path.startsWith('lib/')
      ? jsId.path.replaceFirst('lib/', 'packages/${jsId.package}/')
      : jsId.path;
  return jsPath.substring(0, jsPath.length - jsModuleExtension.length);
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

/// Resolves module [id] for Dart package names to their absolute filenames.
/// Regular NodeJS module IDs are returned as-is.
function resolveId(id) {
  if (id in modulePaths) {
    var parts = __dirname.split(path.sep);
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
