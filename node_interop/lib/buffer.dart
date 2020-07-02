// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "buffer" module bindings.
///
/// Normally there should be no need to import this module directly as
/// [Buffer] class is available globally.
@JS()
library node_interop.buffer;

import 'package:js/js.dart';

import 'node.dart';

BufferModule get buffer => _buffer ??= require('buffer');
BufferModule _buffer;

@JS()
@anonymous
abstract class BufferModule {
  external BufferConstants get constants;

  /// Returns the maximum number of bytes that will be returned when
  /// [Buffer.inspect] is called.
  external int get INSPECT_MAX_BYTES;

  /// An alias for [BufferConstants.MAX_LENGTH].
  external int get kMaxLength;

  /// Re-encodes the given [source] Buffer or Uint8Array instance from one
  /// character encoding to another. Returns a new Buffer instance.
  external Buffer transcode(source, String fromEnc, String toEnc);
}

@JS()
@anonymous
abstract class BufferConstants {
  /// On 32-bit architectures, this value is (2^30)-1 (~1GB).
  /// On 64-bit architectures, this value is (2^31)-1 (~2GB).
  external int get MAX_LENGTH;

  /// Represents the largest length that a string primitive can have,
  /// counted in UTF-16 code units.
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

  /// Allocates a new Buffer of size bytes.
  ///
  /// The underlying memory for Buffer instances created in this way is not
  /// initialized. The contents of the newly created Buffer are unknown and may
  /// contain sensitive data. Use [Buffer.fill] to initialize such Buffer
  /// instances to zeroes.
  external static Buffer allocUnsafeSlow(int size);

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

  /// Returns `true` if [encoding] contains a supported character encoding,
  /// or false otherwise.
  external static bool isEncoding(String encoding);

  /// This is the number of bytes used to determine the size of pre-allocated,
  /// internal Buffer instances used for pooling.
  ///
  /// This value may be modified.
  external static int get poolSize;
  external static set poolSize(int value);

  // [] and []= operators are not supported by JS interop
  // external operator [](int index);
  // external operator []=(int index, int value);

  external dynamic get buffer;

  // Can not have static and regular methods of the same name in Dart.
  // external bool compare();

  /// Copies data from a region of buf to a region in [target] even if the target
  /// memory region overlaps with buf.
  external bool copy(target, [int targetStart, int sourceStart, int sourceEnd]);

  /// Creates and returns an iterator of (index, byte) pairs from the contents
  /// of this buffer.
  external Iterable<List<int>> entries();

  /// Returns `true` if both this and [other] buffer have exactly the same bytes,
  /// `false` otherwise.
  external bool equals(other);

  /// Fills this buffer with the specified value. If the [offset] and [end] are
  /// not given, the entire buffer will be filled.
  external Buffer fill(value, [int offset, int end, String encoding]);

  /// Equivalent to `indexOf() != -1`.
  external bool includes(value, [int byteOffset, String encoding]);
  external int indexOf(value, [int byteOffset, String encoding]);

  /// Creates and returns an iterator of keys (indices) in this buffer.
  external Iterable<int> keys();

  /// Identical to [indexOf], except buffer is searched from back to front.
  external int lastIndexOf(value, [int byteOffset, String encoding]);

  /// Returns the amount of memory allocated for this buffer in bytes. Note that
  /// this does not necessarily reflect the amount of "usable" data within buffer.
  external int get length;

  /// Reads a 64-bit double from this buffer at the specified offset with
  /// specified endian format.
  external num readDoubleBE(int offset, [bool noAssert]);

  /// Reads a 64-bit double from this buffer at the specified offset with
  /// specified endian format.
  external num readDoubleLE(int offset, [bool noAssert]);

  /// Reads a 32-bit float from this buffer at the specified [offset] with
  /// specified endian format.
  external num readFloatBE(int offset, [bool noAssert]);

  /// Reads a 32-bit float from this buffer at the specified [offset] with
  /// specified endian format.
  external num readFloatLE(int offset, [bool noAssert]);

  /// Reads a signed 8-bit integer from this buffer at the specified [offset].
  external num readInt8(int offset, [bool noAssert]);

  /// Reads a signed 16-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readInt16BE(int offset, [bool noAssert]);

  /// Reads a signed 16-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readInt16LE(int offset, [bool noAssert]);

  /// Reads a signed 32-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readInt32BE(int offset, [bool noAssert]);

  /// Reads a signed 32-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readInt32LE(int offset, [bool noAssert]);

  /// Reads [byteLength] number of bytes from this buffer at the specified [offset]
  /// and interprets the result as a two's complement signed value.
  ///
  /// Supports up to 48 bits of accuracy.
  external int readIntBE(int offset, int byteLength, [bool noAssert]);

  /// Reads [byteLength] number of bytes from this buffer at the specified [offset]
  /// and interprets the result as a two's complement signed value.
  ///
  /// Supports up to 48 bits of accuracy.
  external int readIntLE(int offset, int byteLength, [bool noAssert]);

  /// Reads a unsigned 8-bit integer from this buffer at the specified [offset].
  external num readUInt8(int offset, [bool noAssert]);

  /// Reads a unsigned 16-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readUInt16BE(int offset, [bool noAssert]);

  /// Reads a unsigned 16-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readUInt16LE(int offset, [bool noAssert]);

  /// Reads a unsigned 32-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readUInt32BE(int offset, [bool noAssert]);

  /// Reads a unsigned 32-bit integer from this buffer at the specified [offset]
  /// with specified endian format.
  external num readUInt32LE(int offset, [bool noAssert]);

  /// Reads [byteLength] number of bytes from this buffer at the specified [offset]
  /// and interprets the result as an unsigned integer.
  ///
  /// Supports up to 48 bits of accuracy.
  external int readUIntBE(int offset, int byteLength, [bool noAssert]);

  /// Reads [byteLength] number of bytes from this buffer at the specified [offset]
  /// and interprets the result as an unsigned integer.
  ///
  /// Supports up to 48 bits of accuracy.
  external int readUIntLE(int offset, int byteLength, [bool noAssert]);

  /// Returns a new [Buffer] that references the same memory as the original,
  /// but offset and cropped by the [start] and [end] indices.
  external Buffer slice([int start, int end]);

  /// Interprets this buffer as an array of unsigned 16-bit integers and swaps
  /// the byte-order in-place.
  external Buffer swap16();

  /// Interprets this buffer as an array of unsigned 32-bit integers and swaps
  /// the byte-order in-place.
  external Buffer swap32();

  /// Interprets this buffer as an array of 64-bit numbers and swaps
  /// the byte-order in-place.
  external Buffer swap64();

  /// Returns a JSON representation of this buffer.
  external dynamic toJSON();

  /// Decodes this buffer to a string according to the specified character
  /// [encoding].
  @override
  external String toString([String encoding, int start, int end]);

  /// Creates and returns an iterator for this buffer values (bytes).
  external Iterable<int> values();

  /// Writes string to this buffer at [offset] according to the character
  /// [encoding]. Returns number of bytes written.
  external int write(String string, [int offset, int length, String encoding]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeDoubleBE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeDoubleLE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeFloatBE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeFloatLE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeInt8(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeInt16BE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeInt16LE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeInt32BE(num value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeInt32LE(num value, int offset, [bool noAssert]);

  /// Writes [byteLength] bytes of value at the specified [offset]. Supports up
  /// to 48 bits of accuracy.
  external int writeIntBE(num value, int offset, int byteLength,
      [bool noAssert]);

  /// Writes [byteLength] bytes of value at the specified [offset]. Supports up
  /// to 48 bits of accuracy.
  external int writeIntLE(num value, int offset, int byteLength,
      [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeUInt8(int value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeUInt16BE(int value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeUInt16LE(int value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeUInt32BE(int value, int offset, [bool noAssert]);

  /// Writes value at the specified [offset] with specified endian format.
  /// Returns [offset] plus the number of bytes written.
  external int writeUInt32LE(int value, int offset, [bool noAssert]);

  /// Writes [byteLength] bytes of value at the specified [offset]. Supports up
  /// to 48 bits of accuracy.
  external int writeUIntBE(num value, int offset, int byteLength,
      [bool noAssert]);

  /// Writes [byteLength] bytes of value at the specified [offset]. Supports up
  /// to 48 bits of accuracy.
  external int writeUIntLE(num value, int offset, int byteLength,
      [bool noAssert]);
}
