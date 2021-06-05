// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:build_modules/build_modules.dart';
import 'package:build_node_compilers/build_node_compilers.dart';
import 'package:build_node_compilers/builders.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  late Map<String, Object> assets;

  setUp(() async {
    assets = {
      'b|lib/b.dart': '''final world = 'world';''',
      'a|lib/a.dart': '''
        import 'package:b/b.dart';
        final hello = world;
      ''',
      'a|web/index.dart': '''
        import "package:a/a.dart";
        main() {
          print(hello);
        }
      ''',
    };

    await runPrerequisites(assets);
  });

  test('can bootstrap dart entrypoints', () async {
    // Just do some basic sanity checking, integration tests will validate
    // things actually work.
    var expectedOutputs = {
      'a|web/index.digests': decodedMatches(contains('packages/')),
      'a|web/index.dart.js': decodedMatches(contains('index.dart.bootstrap')),
      'a|web/index.dart.js.map': anything,
      'a|web/index.dart.bootstrap.js': decodedMatches(allOf([
        // Maps non-lib modules to remove the top level dir.
        contains('"web/index": "index.ddc_node"'),
        // Maps lib modules to packages path
        contains('"packages/a/a": "packages/a/a.ddc_node"'),
        contains('"packages/b/b": "packages/b/b.ddc_node"'),
        // Requires the top level module and dart sdk.
        contains("var Module = require('module');"),
        contains('const dart_sdk = require("dart_sdk");'),
        // Exports main on the top level module.
        contains('module.exports.main = app.web__index.main'),
        isNot(contains('lib/a')),
      ])),
    };
    await testBuilder(NodeEntrypointBuilder(WebCompiler.DartDevc), assets,
        outputs: expectedOutputs);
  });
}

// Runs all the DDC related builders except the entrypoint builder.
Future<void> runPrerequisites(Map<String, Object> assets) async {
  await testBuilderAndCollectAssets(const ModuleLibraryBuilder(), assets);
  await testBuilderAndCollectAssets(MetaModuleBuilder(ddcPlatform), assets);
  await testBuilderAndCollectAssets(
      MetaModuleCleanBuilder(ddcPlatform), assets);
  await testBuilderAndCollectAssets(ModuleBuilder(ddcPlatform), assets);
  await testBuilderAndCollectAssets(
      ddcKernelBuilder(BuilderOptions({})), assets);
  await testBuilderAndCollectAssets(
      DevCompilerBuilder(platform: ddcPlatform), assets);
}
