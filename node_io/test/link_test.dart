// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library link_test;

import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

import 'fs_utils.dart';

void main() {
  group('Link', () {
    test('create', () async {
      var filepath = createFile("link_create_test.txt", 'data');
      var linkpath = createPath("link.txt");
      var link = new Link(linkpath);
      var created = await link.create(filepath);
      expect(created.exists(), completion(isTrue));
    });

    test('createSync', () {
      var filepath = createFile("link_create_sync_test.txt", 'data');
      var linkpath = createPath("link_sync.txt");
      var link = new Link(linkpath);
      link.createSync(filepath);
      expect(link.existsSync(), isTrue);
    });
  });
}
