// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library file_test;

import 'package:node_interop/fs.dart';
import 'package:node_io/node_io.dart';
import 'package:path/path.dart';
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

    File file(String name) {
      return new File(join(Directory.current.path, name));
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

    test('delete', () async {
      var path =
          createFile('delete.txt', new String.fromCharCodes([1, 2, 3, 4, 5]));
      var file = new File(path);
      expect(await file.exists(), isTrue);
      await file.delete();
      expect(await file.exists(), isFalse);
    });

    test('create', () async {
      var file = new File('create.txt');
      try {
        await file.delete();
      } catch (_) {}
      expect(await file.exists(), isFalse);
      await file.create();
      expect(await file.exists(), isTrue);

      // cleanup
      await file.delete();
    });

    test('read_write_bytes', () async {
      var file = new File('as_bytes.bin');
      List<int> bytes = [0, 1, 2, 3];

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
      String text = "test";
      var file = new File('as_text.txt');

      await file.writeAsString(text, flush: true);
      expect(await file.readAsString(), text);

      // overwrite
      await file.writeAsString(text, flush: true);
      expect(await file.readAsString(), text);

      // append
      await file.writeAsString(text, mode: FileMode.append, flush: true);
      expect(await file.readAsString(), "$text$text");

      // cleanup
      await file.delete();
    });

    test('add_bytes', () async {
      File file = new File('add_bytes.bin');
      var sink = file.openWrite(mode: FileMode.write);
      sink.add([1, 2, 3, 4]);
      sink.add('test'.codeUnits);
      await sink.flush();
      await sink.close();
      expect(await file.readAsBytes(), [1, 2, 3, 4]..addAll('test'.codeUnits));

      // cleanup
      await file.delete();
    });

    test('rename', () async {
      var src = new File('src');
      var dst = new File('dst');
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
