// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js';

import 'package:node_interop/stream.dart';

/// Creating custom [Readable] and [Writable] streams.
///
/// This example creates a readable stream and pipes its contents into a
/// writable stream. When writable stream finishes all consumed data
/// (string "Hello world") is sent as a result of a [Future] and printed
/// to stdout.
void main() {
  var buffer = StringBuffer();
  var readable = createStringReadStream();
  var writable = createStringBufferStream(buffer);
  var completer = Completer<String>();

  readable.pipe(writable).on('finish', allowInterop(() {
    completer.complete(buffer.toString());
  }));
  completer.future.then(print);
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
