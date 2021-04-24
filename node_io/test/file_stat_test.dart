// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// @dart=2.9

@TestOn('node')
library file_stat_test;

import 'package:node_io/node_io.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group('FileStat', () {
    test('statSync', () {
      var stat = FileStat.statSync(Directory.current.path);
      expect(stat.accessed, const TypeMatcher<DateTime>());
      expect(stat.changed, const TypeMatcher<DateTime>());
      expect(stat.modified, const TypeMatcher<DateTime>());
      expect(stat.type, FileSystemEntityType.directory);
      expect(stat.size, isNotNull);
      expect(stat.mode, isNotNull);
    });

    test('stat_directory', () async {
      var stat = await FileStat.stat(Directory.current.path);
      expect(stat.accessed, const TypeMatcher<DateTime>());
      expect(stat.changed, const TypeMatcher<DateTime>());
      expect(stat.modified, const TypeMatcher<DateTime>());
      expect(stat.type, FileSystemEntityType.directory);
      expect(stat.size, isNotNull);
      expect(stat.mode, isNotNull);

      // missing directory
      stat = await FileStat.stat(join(Directory.current.path, '__dummy__'));
      expect(stat.type, FileSystemEntityType.notFound);
    });
  });
}
