// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "stream" module bindings.
@JS()
library node_interop.stream;

import 'dart:js_util';

import 'package:js/js.dart';

import 'events.dart';
import 'node.dart';

StreamModule get stream => _stream ??= require('stream');
StreamModule _stream;

@JS()
@anonymous
abstract class StreamModule {
  dynamic get Writable;
  dynamic get Readable;
}

Writable createWritable(WritableOptions options) {
  return callConstructor(stream.Writable, [options]);
}

@JS()
@anonymous
abstract class Readable implements EventEmitter {
  external bool isPaused();
  external Readable pause();
  external void pipe(Writable destination, [options]);
  external Readable resume();
  external void setEncoding(String encoding);
  external void destroy([error]);
}

@JS()
@anonymous
abstract class Writable implements EventEmitter {
  external Writable(WritableOptions options);
  external bool write(chunk, [encodingOrCallback, callback]);
  external void end([dynamic data, encodingOrCallback, callback]);
  external void setDefaultEncoding(String encoding);
  external Writable destroy([error]);
}

@JS()
@anonymous
abstract class WritableOptions {
  external factory WritableOptions({
    int highWaterMark,
    bool decodeStrings,
    bool objectMode,
    Function write,
    Function writev,
    Function destroy,
  });
  int get highWaterMark;
  bool get decodeStrings;
  bool get objectMode;
  Function get write;
  Function get writev;
  Function get destroy;
  // Function get final; // Unsupported: final is reserved word in Dart.
}
