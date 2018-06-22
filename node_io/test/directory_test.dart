// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library directory_test;

import 'package:node_interop/node.dart';
import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

void main() {
  group('Directory', () {
    test('current directory', () {
      expect(Directory.current, const TypeMatcher<Directory>());
      expect(Directory.current.path, process.cwd());
    });

    test('exists', () {
      expect(Directory.current.existsSync(), isTrue);
      expect(Directory.current.exists(), completion(isTrue));
      expect(Directory.current.isAbsolute, isTrue);
    });
  });
}
