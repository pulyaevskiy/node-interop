// Copyright (c) 2020, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library file_system_test;

import 'package:node_io/node_io.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

import 'fs_utils.dart';

void main() {
  group('nodeFileSystem', () {
    group('identical', () {
      test('returns true for the same file', () async {
        expect(
            await nodeFileSystem.identical('README.md', 'README.md'), isTrue);
      });

      test('returns true for the same directory', () async {
        expect(await nodeFileSystem.identical('lib', 'lib'), isTrue);
      });

      test('returns true for the same link', () async {
        var filepath =
            createFile('file_system_async_identical_true_test.txt', 'data');
        var linkpath = createPath('file_system_async_identical_true.txt');
        await Link(linkpath).create(filepath);

        expect(await nodeFileSystem.identical(linkpath, linkpath), isTrue);
      });

      test('returns true for different paths to the same file', () async {
        expect(await nodeFileSystem.identical('lib', absolute('lib')), isTrue);
      });

      test('returns false for different files', () async {
        expect(await nodeFileSystem.identical('README.md', 'pubspec.yaml'),
            isFalse);
      });

      test('returns false for a link and its target', () async {
        var filepath =
            createFile('file_system_async_identical_false_test.txt', 'data');
        var linkpath = createPath('file_system_async_identical_false.txt');
        await Link(linkpath).create(filepath);

        expect(await nodeFileSystem.identical(linkpath, filepath), isFalse);
      });

      test('throws an error for non-existent files', () async {
        expect(
            nodeFileSystem.identical('non-existent-file', 'non-existent-file'),
            throwsA(anything));
      });
    });

    group('identicalSync', () {
      test('returns true for the same file', () {
        expect(nodeFileSystem.identicalSync('README.md', 'README.md'), isTrue);
      });

      test('returns true for the same directory', () {
        expect(nodeFileSystem.identicalSync('lib', 'lib'), isTrue);
      });

      test('returns true for the same link', () async {
        var filepath =
            createFile('file_system_sync_identical_true_test.txt', 'data');
        var linkpath = createPath('file_system_sync_identical_true.txt');
        await Link(linkpath).create(filepath);

        expect(nodeFileSystem.identicalSync(linkpath, linkpath), isTrue);
      });

      test('returns true for different paths to the same file', () {
        expect(nodeFileSystem.identicalSync('lib', absolute('lib')), isTrue);
      });

      test('returns false for different files', () {
        expect(
            nodeFileSystem.identicalSync('README.md', 'pubspec.yaml'), isFalse);
      });

      test('returns false for a link and its target', () async {
        var filepath =
            createFile('file_system_sync_identical_false_test.txt', 'data');
        var linkpath = createPath('file_system_sync_identical_false.txt');
        await Link(linkpath).create(filepath);

        expect(nodeFileSystem.identicalSync(linkpath, filepath), isFalse);
      });

      test('throws an error for non-existent files', () {
        expect(
            () => nodeFileSystem.identicalSync(
                'non-existent-file', 'non-existent-file'),
            throwsA(anything));
      });
    });

    group('type', () {
      group('with followLinks: true', () {
        test('returns file for a file', () async {
          expect(await nodeFileSystem.type('README.md'),
              FileSystemEntityType.file);
        });

        test('returns directory for a directory', () async {
          expect(
              await nodeFileSystem.type('lib'), FileSystemEntityType.directory);
        });

        test('returns file for a link to a file', () async {
          var linkpath = createPath('file_system_type_async_file_follow.txt');
          await Link(linkpath).create(absolute('README.md'));

          expect(
              await nodeFileSystem.type(linkpath), FileSystemEntityType.file);
        });

        test('returns directory for a link to a directory', () async {
          var linkpath = createPath('file_system_type_async_dir_follow');
          await Link(linkpath).create(absolute('lib'));

          expect(await nodeFileSystem.type(linkpath),
              FileSystemEntityType.directory);
        });

        test('returns notFound for a broken link', () async {
          var linkpath = createPath('file_system_type_async_link_follow');
          await Link(linkpath).create('non-existent-path');

          expect(await nodeFileSystem.type(linkpath),
              FileSystemEntityType.notFound);
        });

        test('returns notFound for a non-existent path', () async {
          expect(await nodeFileSystem.type('non-existent-path'),
              FileSystemEntityType.notFound);
        });
      });

      group('with followLinks: false', () {
        test('returns file for a file', () async {
          expect(await nodeFileSystem.type('README.md', followLinks: false),
              FileSystemEntityType.file);
        });

        test('returns directory for a directory', () async {
          expect(await nodeFileSystem.type('lib', followLinks: false),
              FileSystemEntityType.directory);
        });

        test('returns link for a link to a file', () async {
          var linkpath = createPath('file_system_type_async_file_nofollow.txt');
          await Link(linkpath).create(absolute('README.md'));

          expect(await nodeFileSystem.type(linkpath, followLinks: false),
              FileSystemEntityType.link);
        });

        test('returns link for a broken link', () async {
          var linkpath = createPath('file_system_type_async_link_nofollow');
          await Link(linkpath).create('non-existent-path');

          expect(await nodeFileSystem.type(linkpath, followLinks: false),
              FileSystemEntityType.link);
        });

        test('returns notFound for a non-existent path', () async {
          expect(
              await nodeFileSystem.type('non-existent-path',
                  followLinks: false),
              FileSystemEntityType.notFound);
        });
      });
    });

    group('typeSync', () {
      group('with followLinks: true', () {
        test('returns file for a file', () {
          expect(
              nodeFileSystem.typeSync('README.md'), FileSystemEntityType.file);
        });

        test('returns directory for a directory', () {
          expect(
              nodeFileSystem.typeSync('lib'), FileSystemEntityType.directory);
        });

        test('returns file for a link to a file', () async {
          var linkpath = createPath('file_system_type_sync_file_follow.txt');
          await Link(linkpath).create(absolute('README.md'));

          expect(nodeFileSystem.typeSync(linkpath), FileSystemEntityType.file);
        });

        test('returns directory for a link to a directory', () async {
          var linkpath = createPath('file_system_type_sync_dir_follow');
          await Link(linkpath).create(absolute('lib'));

          expect(nodeFileSystem.typeSync(linkpath),
              FileSystemEntityType.directory);
        });

        test('returns notFound for a broken link', () async {
          var linkpath = createPath('file_system_type_sync_link_follow');
          await Link(linkpath).create('non-existent-path');

          expect(
              nodeFileSystem.typeSync(linkpath), FileSystemEntityType.notFound);
        });

        test('returns notFound for a non-existent path', () {
          expect(nodeFileSystem.typeSync('non-existent-path'),
              FileSystemEntityType.notFound);
        });
      });

      group('with followLinks: false', () {
        test('returns file for a file', () {
          expect(nodeFileSystem.typeSync('README.md', followLinks: false),
              FileSystemEntityType.file);
        });

        test('returns directory for a directory', () {
          expect(nodeFileSystem.typeSync('lib', followLinks: false),
              FileSystemEntityType.directory);
        });

        test('returns link for a link to a file', () async {
          var linkpath = createPath('file_system_type_sync_file_nofollow.txt');
          await Link(linkpath).create(absolute('README.md'));

          expect(nodeFileSystem.typeSync(linkpath, followLinks: false),
              FileSystemEntityType.link);
        });

        test('returns link for a broken link', () async {
          var linkpath = createPath('file_system_type_sync_link_nofollow');
          await Link(linkpath).create('non-existent-path');

          expect(nodeFileSystem.typeSync(linkpath, followLinks: false),
              FileSystemEntityType.link);
        });

        test('returns notFound for a non-existent path', () {
          expect(
              nodeFileSystem.typeSync('non-existent-path', followLinks: false),
              FileSystemEntityType.notFound);
        });
      });
    });
  });
}
