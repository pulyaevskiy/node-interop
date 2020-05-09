// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "stream" module bindings.
@JS()
library node_interop.stream;

import 'dart:js_util';

import 'package:js/js.dart';

import 'events.dart';
import 'node.dart';

/// The "stream" module's object as returned from [require] call.
StreamModule get stream => _stream ??= require('stream');
StreamModule _stream;

@JS()
@anonymous
abstract class StreamModule {
  /// Reference to constructor function of [Writable].
  Function get Writable;

  /// Reference to constructor function of [Readable].
  Function get Readable;
}

/// Creates custom [Writable] stream with provided [options].
///
/// This is the same as `callConstructor(stream.Writable, [options]);`.
Writable createWritable(WritableOptions options) {
  return callConstructor(stream.Writable, [options]);
}

/// Creates custom [Readable] stream with provided [options].
///
/// This is the same as `callConstructor(stream.Readable, [options]);`.
Readable createReadable(ReadableOptions options) {
  return callConstructor(stream.Readable, [options]);
}

@JS()
@anonymous
abstract class Readable implements EventEmitter {
  external bool isPaused();
  external Readable pause();
  external Writable pipe(Writable destination, [options]);
  external int get readableHighWaterMark;
  external dynamic read([int size]);
  external int get readableLength;
  external Readable resume();
  external void setEncoding(String encoding);
  external void unpipe([Writable destination]);
  external void unshift(chunk);
  external void wrap(stream);
  external void destroy([error]);
  external bool push(chunk, [encoding]);
}

@JS()
@anonymous
abstract class Writable implements EventEmitter {
  external void cork();
  external void end([data, encodingOrCallback, void Function() callback]);
  external void setDefaultEncoding(String encoding);
  external void uncork();
  external int get writableHighWaterMark;
  external int get writableLength;
  external /*bool*/ dynamic write(chunk,
      [encodingOrCallback, void Function() callback]);
  external Writable destroy([error]);
}

/// Duplex streams are streams that implement both the [Readable] and [Writable]
/// interfaces.
@JS()
@anonymous
abstract class Duplex implements Readable, Writable {}

/// Transform streams are [Duplex] streams where the output is in some way
/// related to the input.
@JS()
@anonymous
abstract class Transform implements Duplex {}

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

@JS()
@anonymous
abstract class ReadableOptions {
  external factory ReadableOptions({
    int highWaterMark,
    String encoding,
    bool objectMode,
    Function read,
    Function destroy,
  });
  int get highWaterMark;
  String get encoding;
  bool get objectMode;
  Function get read;
  Function get destroy;
}
