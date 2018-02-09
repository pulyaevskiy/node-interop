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
  });

  test("can compile ddc modules under lib and web", () async {
    var expectedOutputs = {
      'b|lib/b$jsModuleExtension': decodedMatches(contains('world')),
      'b|lib/b$jsSourceMapExtension': decodedMatches(contains('b.dart')),
      'a|lib/a$jsModuleExtension': decodedMatches(contains('hello')),
      'a|lib/a$jsSourceMapExtension': decodedMatches(contains('a.dart')),
      'a|web/index$jsModuleExtension': decodedMatches(contains('main')),
      'a|web/index$jsSourceMapExtension':
          decodedMatches(contains('index.dart')),
    };
    await testBuilder(new DevCompilerBuilder(), assets,
        outputs: expectedOutputs);
  });
}
