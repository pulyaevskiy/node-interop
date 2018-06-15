// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library directory_test;

import 'package:node_interop/node.dart';
import 'package:node_io/node_io.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group('Directory', () {
    test('current directory', () {
      expect(Directory.current, new isInstanceOf<Directory>());
      expect(Directory.current.path, process.cwd());
    });

    test('exists', () async {
      expect(Directory.current.existsSync(), isTrue);
      expect(Directory.current.exists(), completion(isTrue));
      expect(Directory.current.isAbsolute, isTrue);

      expect(
          await new Directory(join(Directory.current.path, "__dummy__"))
              .exists(),
          isFalse);
    });

    test('stat', () async {
      expect(
          (await new Directory(join(Directory.current.path, "__dummy__"))
                  .stat())
              .type,
          FileSystemEntityType.notFound);
      expect(
          (await new Directory(join(Directory.current.path, "lib")).stat())
              .type,
          FileSystemEntityType.directory);
    });

    test('statSync', () async {
      expect(
          new Directory(join(Directory.current.path, "__dummy__"))
              .statSync()
              .type,
          FileSystemEntityType.notFound);
      expect(new Directory(join(Directory.current.path, "lib")).statSync().type,
          FileSystemEntityType.directory);
    });
  });
}
