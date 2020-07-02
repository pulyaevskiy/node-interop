// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'package:node_interop/buffer.dart';
import 'package:test/test.dart';

void main() {
  group('Buffer', () {
    test('from array', () {
      final buffer = Buffer.from([1, 2, 3]);
      // expect(buffer, const TypeMatcher<Buffer>()); // TODO: fails in dart2js
      expect(buffer, [1, 2, 3]);
    });

    test('keys()', () {
      final buffer = Buffer.from([1, 2, 3]);
      expect(List.from(buffer.keys()), [0, 1, 2]);
    }, skip: 'Broken in dart2js');

    test('values()', () {
      final buffer = Buffer.from([1, 2, 3]);
      expect(List.from(buffer.values()), [1, 2, 3]);
    }, skip: 'Broken in dart2js');

    test('entries()', () {
      final buffer = Buffer.from([1, 2, 3]);
      expect(List.from(buffer.entries()), [
        [0, 1],
        [1, 2],
        [2, 3]
      ]);
    }, skip: 'Broken in dart2js');
  });
}
