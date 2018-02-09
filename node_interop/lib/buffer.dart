// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NodeJS buffer module.
///
/// Normally there should be no need to import this module directly as
/// [Buffer] class is available globally.
@JS()
library node_interop.buffer;

import 'package:js/js.dart';

import 'node.dart';

BufferModule get buffer => require('buffer');

@JS()
@anonymous
abstract class BufferModule {
  external BufferConstants get constants;
}

@JS()
@anonymous
abstract class BufferConstants {
  external int get MAX_LENGTH;
  external int get MAX_STRING_LENGTH;
}

@JS()
abstract class Buffer {
  /// Creates a new [Buffer] from data.
  external static Buffer from(data, [arg1, arg2]);

  /// Allocates a new [Buffer] of size bytes.
  ///
  /// If [fill] is undefined, the Buffer will be zero-filled.
  external static Buffer alloc(int size, [fill, String encoding]);

  /// Allocates a new Buffer of size bytes.
  ///
  /// If the size is larger than [BufferConstants.MAX_LENGTH] or smaller than 0,
  /// a RangeError will be thrown. A zero-length Buffer will be created if
  /// size is 0.
  external static Buffer allocUnsafe(int size);

  /// Returns the actual byte length of a string.
  external static Buffer byteLength(string, [encoding]);

  /// Compares [buf1] to [buf2] typically for the purpose of sorting arrays of
  /// Buffer instances.
  external static int compare(buf1, buf2);

  /// Returns a new Buffer which is the result of concatenating all the Buffer
  /// instances in the list together.
  external static Buffer concat(List list, [int totalLength]);

  /// Returns `true` if [obj] is a [Buffer], `false` otherwise.
  external static bool isBuffer(obj);

  /// This is the number of bytes used to determine the size of pre-allocated,
  /// internal Buffer instances used for pooling.
  ///
  /// This value may be modified.
  external static int get poolSize;
  external static set poolSize(int value);

  external operator [](int index);
  external operator []=(int index, int value);
}
