// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'dart:async';
import 'dart:js';

import 'package:node_interop/stream.dart';
import 'package:test/test.dart';

void main() {
  group('stream', () {
    test('integration', () async {
      var b = StringBuffer();
      var r = createStringReadStream();
      var w = createStringBufferStream(b);
      var completer = Completer<String>();

      r.pipe(w).on('finish', allowInterop(() {
        completer.complete(b.toString());
      }));
      expect(completer.future, completion('Hello world'));
    });
  });
}

Readable createStringReadStream() {
  return createReadable(ReadableOptions(
      encoding: 'utf8',
      read: allowInteropCaptureThis((Readable obj, int size) {
        obj.push('Hello world');
        obj.push(null);
      })));
}

Writable createStringBufferStream(StringBuffer buffer) {
  return createWritable(WritableOptions(
    decodeStrings: false,
    write: allowInterop((String chunk, encoding, Function callback) {
      buffer.write(chunk);
      callback();
    }),
  ));
}
