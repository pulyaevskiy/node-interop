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

    _listContainsPath(List<FileSystemEntity> entities, String path) {
      bool contains = false;
      for (var entity in entities) {
        if (entity.path.endsWith(path)) {
          contains = true;
          break;
        }
      }
      return contains;
    }

    test('list', () async {
      var list = await Directory.current.list().toList();
      expect(_listContainsPath(list, "pubspec.yaml"), isTrue);

      list = await new Directory(join(Directory.current.path, "lib"))
          .list()
          .toList();
      expect(_listContainsPath(list, "node_io.dart"), isTrue);
    });

    test('create_delete', () async {
      var dir = new Directory(join(Directory.current.path, "delete_dir"));
      try {
        await dir.delete();
      } catch (_) {}
      ;
      await dir.create();
      expect(await dir.exists(), isTrue);
      await dir.delete();
      expect(await dir.exists(), isFalse);
    });

    test('rename', () async {
      var src = new Directory('src');
      var dst = new Directory('dst');
      try {
        await src.delete();
      } catch (_) {}
      try {
        await dst.delete();
      } catch (_) {}
      await src.create();
      await src.rename(dst.path);
      expect(await src.exists(), isFalse);
      expect(await dst.exists(), isTrue);

      await dst.delete();
    });
  });
}
