// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

import 'package:build_node_compilers/build_node_compilers.dart';
import 'package:build_modules/build_modules.dart';

import 'util.dart';

main() {
  Map<String, dynamic> assets;

  setUp(() async {
    assets = {
      'build_modules|lib/src/analysis_options.default.yaml': '',
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

    // Set up all the other required inputs for this test.
    await testBuilderAndCollectAssets(new ModuleBuilder(), assets);
    await testBuilderAndCollectAssets(new UnlinkedSummaryBuilder(), assets);
    await testBuilderAndCollectAssets(new LinkedSummaryBuilder(), assets);
    await testBuilderAndCollectAssets(new DevCompilerBuilder(), assets);
  });

  test("can bootstrap dart entrypoints", () async {
    // Just do some basic sanity checking, integration tests will validate
    // things actually work.
    var expectedOutputs = {
      'a|web/index.dart.js': decodedMatches(contains('index.dart.bootstrap')),
      'a|web/index.dart.js.map': anything,
      'a|web/index.dart.bootstrap.js': decodedMatches(allOf([
        // Maps non-lib modules to remove the top level dir.
        contains('"web/index": "index.node.ddc"'),
        // Maps lib modules to packages path
        contains('"packages/a/a": "packages/a/a.node.ddc"'),
        contains('"packages/b/b": "packages/b/b.node.ddc"'),
        isNot(contains('lib/a')),
      ])),
    };
    await testBuilder(new NodeEntrypointBuilder(WebCompiler.DartDevc), assets,
        outputs: expectedOutputs);
  });
}
