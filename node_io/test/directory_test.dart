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
    Directory dir(String name) {
      return Directory(join(Directory.current.path, name));
    }

    test('current directory', () {
      expect(Directory.current, const TypeMatcher<Directory>());
      expect(Directory.current.path, process.cwd());
    });

    test('exists', () async {
      expect(Directory.current.existsSync(), isTrue);
      expect(Directory.current.exists(), completion(isTrue));
      expect(Directory.current.isAbsolute, isTrue);

      expect(dir('__dummy__').exists(), completion(isFalse));
    });

    test('stat', () async {
      expect(
          (await dir('__dummy__').stat()).type, FileSystemEntityType.notFound);
      expect((await dir('lib').stat()).type, FileSystemEntityType.directory);
    });

    test('statSync', () async {
      expect(dir('__dummy__').statSync().type, FileSystemEntityType.notFound);
      expect(dir('lib').statSync().type, FileSystemEntityType.directory);
    });

    bool _listContainsPath(List<FileSystemEntity> entities, String path) {
      var contains = false;
      for (var entity in entities) {
        if (entity.path.endsWith(path)) {
          contains = true;
          break;
        }
      }
      return contains;
    }

    test('systemTemp', () {
      expect(Directory.systemTemp.path, isNotEmpty);
    });

    test('list', () async {
      var list = await Directory.current.list().toList();
      expect(_listContainsPath(list, 'pubspec.yaml'), isTrue);

      list = await dir('lib').list().toList();
      expect(_listContainsPath(list, 'node_io.dart'), isTrue);
    });

    test('listSync', () async {
      var list = Directory.current.listSync();
      expect(_listContainsPath(list, 'pubspec.yaml'), isTrue);

      list = dir('lib').listSync();
      expect(_listContainsPath(list, 'node_io.dart'), isTrue);
    });

    test('createTemp', () async {
      final dir = Directory.systemTemp;
      final tmp = await dir.createTemp('createTemp_');
      expect(tmp.existsSync(), true);
      expect(tmp.path, contains('createTemp_'));
      await tmp.delete(); // just for cleanup
    });

    test('createTemp', () {
      final dir = Directory.systemTemp;
      final tmp = dir.createTempSync('createTempSync_');
      expect(tmp.existsSync(), true);
      expect(tmp.path, contains('createTempSync_'));
      tmp.deleteSync(); // just for cleanup
    });

    test('create_delete', () async {
      var directory = dir('delete_dir');
      try {
        await directory.delete();
      } catch (_) {}
      ;
      await directory.create();
      expect(await directory.exists(), isTrue);
      await directory.delete();
      expect(await directory.exists(), isFalse);
    });

    test('rename', () async {
      var src = Directory('src');
      var dst = Directory('dst');
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
