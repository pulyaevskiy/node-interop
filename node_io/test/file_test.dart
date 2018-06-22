// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library file_test;

import 'package:node_interop/fs.dart';
import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

String createFile(String name, String contents) {
  var segments = Platform.script.pathSegments.toList();
  segments
    ..removeLast()
    ..add(name);
  var jsFilepath =
      Platform.pathSeparator + segments.join(Platform.pathSeparator);
  fs.writeFileSync(jsFilepath, contents);
  return jsFilepath;
}

void main() {
  group('File', () {
    test('existsSync', () async {
      var path = createFile('existsSync.txt', "existsSync");
      var file = new File(path);
      expect(file.existsSync(), isTrue);
    });

    test('readAsBytes', () async {
      var path = createFile(
          'readAsBytes.txt', new String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = new File(path);
      expect(file.existsSync(), isTrue);
      var data = await file.readAsBytes();
      expect(data, [1, 2, 3, 4, 5]);
    });

    test('copy', () async {
      var path =
          createFile('copy.txt', new String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = new File(path);
      final copyPath = path.replaceFirst('copy.txt', 'copy_copy.txt');
      final result = await file.copy(copyPath);
      expect(result, const TypeMatcher<File>());
      expect(result.path, copyPath);
      expect(result.existsSync(), isTrue);
    });

    test('copySync', () async {
      var path = createFile(
          'copy_sync.txt', new String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = new File(path);
      final copyPath = path.replaceFirst('copy_sync.txt', 'copy_sync_copy.txt');
      final result = await file.copy(copyPath);
      expect(result, const TypeMatcher<File>());
      expect(result.path, copyPath);
      expect(result.existsSync(), isTrue);
    });
  });
}
