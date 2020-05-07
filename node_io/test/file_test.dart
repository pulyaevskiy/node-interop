// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library file_test;

import 'dart:async';

import 'package:node_io/node_io.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

import 'fs_utils.dart';

void main() {
  group('File', () {
    test('existsSync', () async {
      var path = createFile('existsSync.txt', 'existsSync');
      var file = File(path);
      expect(file.existsSync(), isTrue);
    });

    File file(String name) {
      return File(join(Directory.current.path, name));
    }

    test('exists', () async {
      expect(await file('__dummy__').exists(), isFalse);
      expect(await file('pubspec.yaml').exists(), isTrue);
    });

    test('stat', () async {
      expect(
          (await file('__dummy__').stat()).type, FileSystemEntityType.notFound);
      expect(
          (await file('pubspec.yaml').stat()).type, FileSystemEntityType.file);
    });

    test('statSync', () async {
      expect(file('__dummy__').statSync().type, FileSystemEntityType.notFound);
      expect(file('pubspec.yaml').statSync().type, FileSystemEntityType.file);
    });

    test('readAsBytes', () async {
      var path =
          createFile('readAsBytes.txt', String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = File(path);
      expect(file.existsSync(), isTrue);
      var data = await file.readAsBytes();
      expect(data, [1, 2, 3, 4, 5]);
    });

    test('readAsLines', () async {
      var path = createFile('readAsLines.txt', 'hello world\nsecond line');
      var file = File(path);
      var lines = await file.readAsLines();
      expect(lines, ['hello world', 'second line']);
    });

    test('readAsLinesSync', () {
      var path = createFile('readAsLinesSync.txt', 'hello world\nsecond line');
      var file = File(path);
      var lines = file.readAsLinesSync();
      expect(lines, ['hello world', 'second line']);
    });

    test('readAsBytesSync', () async {
      var path = createFile(
          'readAsBytesSync.txt', String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = File(path);
      expect(file.existsSync(), isTrue);
      var data = file.readAsBytesSync();
      expect(data, [1, 2, 3, 4, 5]);
    });

    test('readAsStringSync', () async {
      var path = createFile('readAsStringSync.txt', 'hello world');
      var file = File(path);
      expect(file.existsSync(), isTrue);
      var data = file.readAsStringSync();
      expect(data, 'hello world');
    });

    test('renameSync', () async {
      var path = createFile('renameSync.txt', 'hello world');
      var file = File(path);
      expect(file.existsSync(), isTrue);
      final renamedPath =
          file.path.replaceFirst('renameSync.txt', 'renamedSync.txt');
      file.renameSync(renamedPath);
      final renamed = File(renamedPath);
      expect(file.existsSync(), isFalse);
      expect(renamed.existsSync(), isTrue);
    });

    test('copy', () async {
      var path = createFile('copy.txt', String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = File(path);
      final copyPath = path.replaceFirst('copy.txt', 'copy_copy.txt');
      final result = await file.copy(copyPath);
      expect(result, const TypeMatcher<File>());
      expect(result.path, copyPath);
      expect(result.existsSync(), isTrue);
    });

    test('copySync', () async {
      var path =
          createFile('copy_sync.txt', String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = File(path);
      final copyPath = path.replaceFirst('copy_sync.txt', 'copy_sync_copy.txt');
      final result = await file.copy(copyPath);
      expect(result, const TypeMatcher<File>());
      expect(result.path, copyPath);
      expect(result.existsSync(), isTrue);
    });

    test('delete', () async {
      var path =
          createFile('delete.txt', String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = File(path);
      expect(await file.exists(), isTrue);
      await file.delete();
      expect(await file.exists(), isFalse);
    });

    test('create', () async {
      var file = File('create.txt');
      try {
        await file.delete();
      } catch (_) {}
      expect(await file.exists(), isFalse);
      await file.create();
      expect(await file.exists(), isTrue);

      // cleanup
      await file.delete();
    });

    test('createSync', () {
      final file = File(join(Directory.systemTemp.path, 'create_sync.txt'));
      if (file.existsSync()) {
        file.deleteSync();
      }
      expect(file.existsSync(), isFalse);

      file.createSync();
      expect(file.existsSync(), isTrue);

      file.deleteSync(); // cleanup
    });

    test('read_write_bytes', () async {
      var file = File('as_bytes.bin');
      final bytes = <int>[0, 1, 2, 3];

      await file.writeAsBytes(bytes, flush: true);
      expect(await file.readAsBytes(), bytes);

      // overwrite
      await file.writeAsBytes(bytes, flush: true);
      expect(await file.readAsBytes(), bytes);

      // append
      await file.writeAsBytes(bytes, mode: FileMode.append, flush: true);
      expect(await file.readAsBytes(), [0, 1, 2, 3, 0, 1, 2, 3]);

      expect(await file.openRead().toList(), [
        [0, 1, 2, 3, 0, 1, 2, 3]
      ]);
      // cleanup
      await file.delete();
    });

    test('read_write_string', () async {
      final text = 'test';
      final file = File('as_text.txt');

      await file.writeAsString(text, flush: true);
      expect(await file.readAsString(), text);

      // overwrite
      await file.writeAsString(text, flush: true);
      expect(await file.readAsString(), text);

      // append
      await file.writeAsString(text, mode: FileMode.append, flush: true);
      expect(await file.readAsString(), '$text$text');

      // cleanup
      await file.delete();
    });

    test('add_bytes', () async {
      final file = File('add_bytes.bin');
      var sink = file.openWrite(mode: FileMode.write);
      sink.add([1, 2, 3, 4]);
      sink.add('test'.codeUnits);
      await sink.flush();
      await sink.close();
      // ignore: prefer_spread_collections
      expect(await file.readAsBytes(), [1, 2, 3, 4]..addAll('test'.codeUnits));

      // cleanup
      await file.delete();
    });

    test('rename', () async {
      var src = File('src');
      var dst = File('dst');
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

    test('setLastAccessed', () async {
      var path = createFile('setLastAccessed.txt', 'file');
      var file = File(path);
      final atime = file.statSync().accessed;
      await Future.delayed(Duration(seconds: 1));
      final now = DateTime.now();
      await file.setLastAccessed(now);
      expect(file.statSync().accessed.isAfter(atime), isTrue);
    });

    test('setLastAccessedSync', () async {
      var path = createFile('setLastAccessed.txt', 'file');
      var file = File(path);
      final atime = file.statSync().accessed;
      await Future.delayed(Duration(seconds: 1));
      final now = DateTime.now();
      file.setLastAccessedSync(now);
      expect(file.statSync().accessed.isAfter(atime), isTrue);
    });

    test('writeAsBytesSync', () async {
      var path = createPath('writeAsBytesSync.txt');
      var file = File(path);
      if (file.existsSync()) file.deleteSync();

      file.writeAsBytesSync([1, 2, 3, 4, 5]);
      expect(file.existsSync(), isTrue);
      var data = file.readAsBytesSync();
      expect(data, [1, 2, 3, 4, 5]);
    });
  });

  group('RandomAccessFile', () {
    test('read', () async {
      var path = createFile('setLastAccessed.txt', 'file');
      var file = File(path);
      var fd = await file.open();
      var result = await fd.read(4);
      var content = String.fromCharCodes(result);
      expect(content, 'file');
      expect(await fd.position(), 4);
      await fd.close();
    });
  });
}
