// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'package:node_interop/fs.dart';
import 'package:test/test.dart';
import 'package:node_interop/src/bindings/process.dart';

void main() {
  group('NodeFileSystem', () {
    var fs = new NodeFileSystem();

    test('stat', () {
      var stat = fs.statSync(fs.currentDirectory.path);
      expect(stat.accessed, new isInstanceOf<DateTime>());
      expect(stat.changed, new isInstanceOf<DateTime>());
      expect(stat.modified, new isInstanceOf<DateTime>());
      expect(stat.type, FileSystemEntityType.DIRECTORY);
      expect(stat.size, isNotNull);
      expect(stat.mode, isNotNull);

      expect(fs.stat(fs.currentDirectory.path),
          completion(new isInstanceOf<FileStat>()));
    });

    test('current directory', () {
      expect(fs.currentDirectory, new isInstanceOf<Directory>());
      expect(fs.currentDirectory.path, process.cwd());
    });

    test('Directory', () {
      expect(fs.currentDirectory.existsSync(), isTrue);
      expect(fs.currentDirectory.exists(), completion(isTrue));
      expect(fs.currentDirectory.isAbsolute, isTrue);
    });
  });
}
