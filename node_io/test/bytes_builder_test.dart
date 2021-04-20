// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// @dart=2.9

@TestOn('node')
library bytes_builder_test;

import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

void main() {
  group('BytesBuilder', () {
    test('smoke test', () {
      var bb = BytesBuilder();
      bb..addByte(1)..addByte(5)..addByte(7);
      expect(bb.toBytes(), [1, 5, 7]);
    });
  });
}
