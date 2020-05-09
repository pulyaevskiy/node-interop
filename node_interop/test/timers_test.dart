// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'dart:async';
import 'dart:js';

import 'package:node_interop/timers.dart';
import 'package:test/test.dart';

void main() {
  group('Timers', () {
    test('setImmediate', () async {
      var buffer = StringBuffer();

      void writesToBuffer(StringBuffer buffer) async {
        buffer.writeln('before');
        await setImmediateFuture(buffer);
        buffer.writeln('after');
      }

      await writesToBuffer(buffer);
      expect(buffer.toString(), 'before\nhello world\nafter\n');
    });
  });
}

Future setImmediateFuture(StringBuffer buffer) {
  final completer = Completer<String>();
  setImmediate(allowInterop((StringBuffer value) {
    value.writeln('hello world');
    completer.complete();
  }), buffer);

  return completer.future;
}
