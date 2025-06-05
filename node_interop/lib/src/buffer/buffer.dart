// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

/// The [Node.js `Buffer` class].
///
/// [Node.js `Buffer` class]: https://nodejs.org/docs/latest/api/buffer.html#class-buffer
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
extension type Buffer._(JSUint8Array _) implements JSUint8Array {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferallocsize-fill-encoding
  external static Buffer alloc(int size, [JSAny? fill, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferallocunsafesize
  external static Buffer allocUnsafe(int size);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferallocunsafeslowsize
  external static Buffer allocUnsafeSlow(int size);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferbytelengthstring-encoding
  external static int byteLength(JSAny string, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferconcatlist-totallength
  static Buffer concat(List<JSUint8Array> list, [int? totalLength]) =>
      totalLength == null
          ? _concat(list.toJS)
          : _concat(list.toJS, totalLength);

  @JS('concat')
  external static Buffer _concat(JSArray<JSUint8Array> list,
      [int? totalLength]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-buffercopybytesfromview-offset-length
  external static Buffer copyBytesFrom(JSTypedArray view,
      [int? offset, int? length]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferfromarray
  static Buffer fromList(List<int> array) => _fromList(array.toJS);

  @JS('from')
  external static Buffer _fromList(JSArray<JSNumber> array);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferfrombuffer
  @JS('from')
  external static Buffer fromBuffer(JSUint8Array buffer);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferfromobject-offsetorencoding-length
  external static Buffer from(JSObject object, [int? offset, int? length]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferfromobject-offsetorencoding-length
  external static Buffer fromWithEncoding(JSObject object, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferfromstring-encoding
  @JS('from')
  external static Buffer fromString(String string, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferisbufferobj
  external static bool isBuffer(JSAny? obj);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-bufferisencodingencoding
  external static bool isEncoding(String? encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#class-property-bufferpoolsize
  external static int poolSize;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufcomparetarget-targetstart-targetend-sourcestart-sourceend
  external int compare(JSUint8Array target,
      [int? targetStart, int? targetEnd, int? sourceStart, int? sourceEnd]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufcopytarget-targetstart-sourcestart-sourceend
  external int copy(JSUint8Array target,
      [int? targetStart, int? targetEnd, int? sourceStart, int? sourceEnd]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufequalsotherbuffer
  external bool equals(JSUint8Array other);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buffillvalue-offset-end-encoding
  @JS('fill')
  external void fillWithBuffer(JSUint8Array value, [int? start, int? end]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buffillvalue-offset-end-encoding
  @JS('fill')
  external void fillWithString(String value,
      [int? start, int? end, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufincludesvalue-byteoffset-encoding
  @JS('includes')
  external bool includesBuffer(JSUint8Array value, [int? byteOffset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufincludesvalue-byteoffset-encoding
  @JS('includes')
  external bool includesString(String value,
      [int? byteOffset, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufindexofvalue-byteoffset-encoding
  @JS('indexOf')
  external int indexOfBuffer(JSUint8Array value, [int? byteOffset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufindexofvalue-byteoffset-encoding
  int indexOfString(String value, {int? byteOffset, String? encoding}) {
    if (byteOffset == null) {
      if (encoding == null) return _indexOfString(value);
      return _indexOfString(value, encoding.toJS);
    } else if (encoding == null) {
      return _indexOfString(value, byteOffset.toJS);
    } else {
      return _indexOfString(value, byteOffset.toJS, encoding);
    }
  }

  @JS('indexOf')
  external int _indexOfString(String value,
      [JSAny? byteOffset, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buflastindexofvalue-byteoffset-encoding
  @JS('lastIndexOf')
  external int lastIndexOfBuffer(JSUint8Array value, [int? byteOffset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buflastindexofvalue-byteoffset-encoding
  int lastIndexOfString(String value, {int? byteOffset, String? encoding}) {
    if (byteOffset == null) {
      if (encoding == null) return _lastIndexOfString(value);
      return _lastIndexOfString(value, encoding.toJS);
    } else if (encoding == null) {
      return _lastIndexOfString(value, byteOffset.toJS);
    } else {
      return _lastIndexOfString(value, byteOffset.toJS, encoding);
    }
  }

  @JS('lastIndexOf')
  external int _lastIndexOfString(String value,
      [JSAny? byteOffset, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadbigint64beoffset
  external JSBigInt readBigInt64BE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadbigint64leoffset
  external JSBigInt readBigInt64LE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadbiguint64beoffset
  @JS('readBigUInt64BE')
  external JSBigInt readBigUint64BE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadbiguint64leoffset
  @JS('readBigUInt64LE')
  external JSBigInt readBigUint64LE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaddoublebeoffset
  external double readDoubleBE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaddoubleleoffset
  external double readDoubleLE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadfloatbeoffset
  external double readFloatBE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadfloatleoffset
  external double readFloatLE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadint8offset
  external int readInt8([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadint16beoffset
  external int readInt16BE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadint16leoffset
  external int readInt16LE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadint32beoffset
  external int readInt32BE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadint32leoffset
  external int readInt32LE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadintbeoffset-bytelength
  external int readIntBE(int offset, int byteLength);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreadintleoffset-bytelength
  external int readIntLE(int offset, int byteLength);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduint8offset
  @JS('readUInt8')
  external int readUint8([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduint16beoffset
  @JS('readUInt16BE')
  external int readUint16BE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduint16leoffset
  @JS('readUInt16LE')
  external int readUint16LE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduint32beoffset
  @JS('readUInt32BE')
  external int readUint32BE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduint32leoffset
  @JS('readUInt32LE')
  external int readUint32LE([int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduintbeoffset
  @JS('readUIntBE')
  external int readUintBE(int offset, int byteLength);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufreaduintleoffset
  @JS('readUIntLE')
  external int readUintLE(int offset, int byteLength);

  /// See [`TypedArray.filter()`].
  ///
  /// [`TypedArray.filter()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/filter
  Buffer filter(bool Function(int element) callback) => _filter(callback.toJS);

  /// See [`TypedArray.filter()`].
  ///
  /// [`TypedArray.filter()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/filter
  Buffer filterWithIndex(bool Function(int element, int index) callback) =>
      _filter(callback.toJS);

  @JS('filter')
  external Buffer _filter(JSFunction callback);

  /// See [`TypedArray.map()`].
  ///
  /// [`TypedArray.map()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/map
  Buffer map(int Function(int element) callback) => _map(callback.toJS);

  /// See [`TypedArray.map()`].
  ///
  /// [`TypedArray.map()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/map
  Buffer mapWithIndex(int Function(int element, int index) callback) =>
      _map(callback.toJS);

  @JS('map')
  external Buffer _map(JSFunction callback);

  /// See [`TypedArray.subarray()`].
  ///
  /// [`TypedArray.subarray()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/subarray
  external Buffer subarray([int? begin, int? end]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufswap16
  external void swap16();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufswap32
  external void swap32();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufswap64
  external void swap64();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buftojson
  @JS('toJSON')
  external String toJson();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buftostringencoding-start-end
  @JS('toString')
  external String toEncodedString(String encoding, [int? start, int? end]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritestring-offset-length-encoding
  external int write(String string,
      [int? offset, int? length, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritestring-offset-length-encoding
  @JS('write')
  external int writeWithEncoding(String string, String encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritebigint64bevalue-offset
  external int writeBigInt64BE(JSBigInt value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritebigint64levalue-offset
  external int writeBigInt64LE(JSBigInt value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritebiguint64bevalue-offset
  @JS('writeBigUInt64BE')
  external int writeBigUint64BE(JSBigInt value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritebiguint64levalue-offset
  @JS('writeBigUint64BE')
  external int writeBigUint64LE(JSBigInt value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritedoublebevalue-offset
  external int writeDoubleBE(double value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritedoublelevalue-offset
  external int writeDoubleLE(double value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritefloatbevalue-offset
  external int writeFloatBE(double value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwritefloatlevalue-offset
  external int writeFloatLE(double value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteint8value-offset
  external int writeInt8(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteint16bevalue-offset
  external int writeInt16BE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteint16levalue-offset
  external int writeInt16LE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteint32bevalue-offset
  external int writeInt32BE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteint32levalue-offset
  external int writeInt32LE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteintbevalue-offset-bytelength
  external int writeIntBE(int value, int offset, int byteLength);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteintlevalue-offset-bytelength
  external int writeIntLE(int value, int offset, int byteLength);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteint8value-offset
  @JS('writeUInt8')
  external int writeUint8(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteuint16bevalue-offset
  @JS('writeUInt16BE')
  external int writeUint16BE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteuint16levalue-offset
  @JS('writeUInt16LE')
  external int writeUint16LE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteuint32bevalue-offset
  @JS('writeUInt32BE')
  external int writeUint32BE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteuint32levalue-offset
  @JS('writeUInt32LE')
  external int writeUint32LE(int value, [int? offset]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteuintbevalue-offset-bytelength
  @JS('writeUIntBE')
  external int writeUintBE(int value, int offset, int byteLength);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufwriteuintlevalue-offset-bytelength
  @JS('writeUIntLE')
  external int writeUintLE(int value, int offset, int byteLength);
}
