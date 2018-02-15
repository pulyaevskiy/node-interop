// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'dart:js';

import 'package:node_interop/console.dart';
import 'package:node_interop/stream.dart';
import 'package:test/test.dart';

void main() {
  group('console', () {
    test('integration', () {
      var console = createConsole(createPrintStream());
      expect(() {
        console.log('hello world');
      }, prints('hello world\n\n'));

      /// Looks like double line-break is because both console.log and print
      /// add it.
    });
  });
}

Writable createPrintStream() {
  return createWritable(new WritableOptions(
    decodeStrings: false,
    write: allowInterop((chunk, encoding, callback) {
      print(chunk);
    }),
  ));
}
