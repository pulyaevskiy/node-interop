// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:async/async.dart';
import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

import '../../fs.dart';
import '../buffer/buffer.dart';
import '../events/event_emitter.dart';
import 'module.dart';

/// The Node.js [`FileHandle` class].
///
/// [`FileHandle` class]: https://nodejs.org/docs/latest/api/fs.html#class-filehandle
extension type FSFileHandle._(JSObject _)
    implements AsyncDisposable, EventEmitter {
  /// Returns whether [value] is a [FSFileHandle].
  static bool isA(JSAny? value) => value.instanceof(fs.fileHandleClass);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlefd
  @JS('fd')
  external int get fileDescriptor;

  /// A Dart [CancelableOperation] wrapping [the `'close'` event].
  ///
  /// [the `'close'` event]: https://nodejs.org/docs/latest/api/fs.html#event-close
  CancelableOperation<void> get onClose =>
      onceAsCancelableOperation('close'.toJS).then((_) {});

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandleappendfiledata-options
  ///
  /// The [data] argument can be a [JSString], [JSTypedArray], [JSDataView],
  /// [JSAsyncIterable], [JSIterable], or [NodeReadable].
  JSPromise<Null> appendFile(JSAny data,
      {String? encoding, AbortSignal? signal}) {
    var options = _AppendFileOptions();
    if (encoding != null) options.encoding = encoding;
    if (signal != null) options.signal = signal;
    return _appendFile(data, options);
  }

  @JS('appendFile')
  external JSPromise<Null> _appendFile(JSAny data, _AppendFileOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlechmodmode
  @JS('chmod')
  external JSPromise<Null> changeMode(int mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlechownuid-gid
  @JS('chown')
  external JSPromise<Null> changeOwner(int uid, int gid);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandleclose
  external JSPromise<Null> close();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlecreatereadstreamoptions
  FSReadStream createReadStream(
      {String? encoding,
      bool? autoClose,
      bool? emitClose,
      int? start,
      int? end,
      int? highWaterMark,
      AbortSignal? signal}) {
    var options = _CreateReadStreamOptions();
    if (encoding != null) options.encoding = encoding;
    if (autoClose != null) options.autoClose = autoClose;
    if (emitClose != null) options.emitClose = emitClose;
    if (start != null) options.start = start;
    if (end != null) options.end = end;
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (signal != null) options.signal = signal;
    return _createReadStream(options);
  }

  @JS('createReadStream')
  external FSReadStream _createReadStream(_CreateReadStreamOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlecreatewritestreamoptions
  FSWriteStream createWriteStream(
      {String? encoding,
      bool? autoClose,
      bool? emitClose,
      int? start,
      int? highWaterMark,
      bool? flush}) {
    var options = _CreateWriteStreamOptions();
    if (encoding != null) options.encoding = encoding;
    if (autoClose != null) options.autoClose = autoClose;
    if (emitClose != null) options.emitClose = emitClose;
    if (start != null) options.start = start;
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (flush != null) options.flush = flush;
    return _createWriteStream(options);
  }

  @JS('createWriteStream')
  external FSWriteStream _createWriteStream(_CreateWriteStreamOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandledatasync
  @JS('dataSync')
  external JSPromise<Null> dataSync();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandleappendfiledata-options
  ///
  /// The [buffer] argument can be a [JSTypedArray] or a [JSDataView]. The
  /// [position] argument can be a [JSNumber] or a [JSBigInt].
  JSPromise<JSNumber> read(JSObject buffer,
      {int? offset, int? length, JSAny? position}) {
    var options = ReadWriteOptions();
    if (offset != null) options.offset = offset;
    if (length != null) options.length = length;
    if (position != null) options.position = position;
    return _read(buffer, options)
        .then(((ReadResult result) => result.bytesRead).toJS);
  }

  @JS('read')
  external JSPromise<ReadResult> _read(
      JSObject buffer, ReadWriteOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlereadablewebstreamoptions
  ReadableStream readableWebStream({bool? autoClose}) => autoClose == null
      ? _readableWebStream()
      : _readableWebStream(_ReadableWebStreamOptions(autoClose: autoClose));

  @JS('readableWebStream')
  external ReadableStream _readableWebStream(
      [_ReadableWebStreamOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlereadfileoptions
  JSPromise<Buffer> readFile({AbortSignal? signal}) => (signal == null
      ? _readFile()
      : _readFile(_ReadWriteFileOptions(signal: signal))) as JSPromise<Buffer>;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlereadfileoptions
  JSPromise<JSString> readFileAsString(String encoding, {AbortSignal? signal}) {
    var options = _ReadWriteFileOptions(encoding: encoding);
    if (signal != null) options.signal = signal;
    return _readFile(options) as JSPromise<JSString>;
  }

  @JS('readFile')
  external JSPromise<JSAny> _readFile([_ReadWriteFileOptions options]);

  // TODO - Add readLines() once we add typings for the readline module.

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlereadvbuffers-position
  ///
  /// The [buffers] argument can contain [JSTypedArray]s or [JSDataView]s. The
  /// [position] argument can be a [JSNumber] or a [JSBigInt].
  JSPromise<JSNumber> readToAll(JSArray<JSObject> buffers, {JSAny? position}) =>
      (position == null ? _readToAll(buffers) : _readToAll(buffers, position))
          .then(((ReadResult result) => result.bytesRead).toJS);

  // The Node.js documentation only lists an integer as allowed for position,
  // but in practice a BigInt works as well (just like [read]).
  @JS('readv')
  external JSPromise<ReadResult> _readToAll(JSArray<JSObject> buffers,
      [JSAny? position]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlestatoptions
  external JSPromise<FSStats> stat();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlestatoptions
  JSPromise<FSBigIntStats> statBigInt() => _stat(StatOptions(bigint: true));

  @JS('stat')
  external JSPromise<FSBigIntStats> _stat([StatOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlesync
  external JSPromise<Null> sync();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandletruncatelen
  external JSPromise<Null> truncate(int length);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandleutimesatime-mtime
  ///
  /// The [atime] and [mtime] parameters may be [JSNumber]s, [JSString]s, or
  /// [JSDate]s.
  @JS('utimes')
  external JSPromise<Null> updateTimes(JSAny atime, JSAny mtime);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlewritebuffer-offset-length-position
  ///
  /// The [buffer] argument can be a [JSTypedArray] or a [JSDataView].
  JSPromise<JSNumber> write(JSObject buffer,
      {int? offset, int? length, int? position}) {
    var options = ReadWriteOptions();
    if (offset != null) options.offset = offset;
    if (length != null) options.length = length;
    if (position != null) options.position = position.toJS;
    return _write(buffer, options)
        .then(((WriteResult result) => result.bytesWritten).toJS);
  }

  @JS('write')
  external JSPromise<WriteResult> _write(
      JSObject buffer, ReadWriteOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlewritestring-position-encoding
  JSPromise<JSNumber> writeString(String string,
          {int? position, String? encoding}) =>
      _writeString(string, position, encoding ?? 'utf8')
          .then(((WriteResult result) => result.bytesWritten).toJS);

  @JS('write')
  external JSPromise<WriteResult> _writeString(String string,
      [int? position, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlewritefiledata-options
  ///
  /// The [data] argument can be a [JSString], [JSTypedArray], [JSDataView], or
  /// a [JSAsyncIterable], [JSIterable], or [NodeReadable] containing any of
  /// those types.
  JSPromise<Null> writeFile(JSAny data,
      {String? encoding, AbortSignal? signal}) {
    var options = _ReadWriteFileOptions();
    if (encoding != null) options.encoding = encoding;
    if (signal != null) options.signal = signal;
    return _writeFile(data, options);
  }

  @JS('writeFile')
  external JSPromise<Null> _writeFile(
      JSAny data, _ReadWriteFileOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlewriteFromAllbuffers-position
  ///
  /// The [buffers] argument can contain [JSTypedArray]s or [JSDataView]s.
  JSPromise<JSNumber> writeFromAll(JSArray<JSObject> buffers,
          {int? position}) =>
      (position == null
              ? _writeFromAll(buffers)
              : _writeFromAll(buffers, position))
          .then(((WriteResult result) => result.bytesWritten).toJS);

  @JS('writev')
  external JSPromise<WriteResult> _writeFromAll(JSArray<JSObject> buffers,
      [int? position]);
}

/// Options for [FSFileHandle.appendFile].
extension type _AppendFileOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external AbortSignal? signal;

  factory _AppendFileOptions() => _AppendFileOptions._(JSObject());
}

/// Options for [FSFileHandle.createReadStream].
extension type _CreateReadStreamOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external bool? autoClose;
  external bool? emitClose;
  external int? start;
  external int? end;
  external int? highWaterMark;
  external AbortSignal? signal;

  factory _CreateReadStreamOptions() => _CreateReadStreamOptions._(JSObject());
}

/// Options for [FSFileHandle.createReadStream].
extension type _CreateWriteStreamOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external bool? autoClose;
  external bool? emitClose;
  external int? start;
  external int? highWaterMark;
  external bool? flush;

  factory _CreateWriteStreamOptions() => _CreateWriteStreamOptions._(JSObject());
}

/// Options for [FSFileHandle.readableWebStream].
extension type _ReadableWebStreamOptions._(JSObject _) implements JSObject {
  external bool? autoClose;

  external _ReadableWebStreamOptions({bool? autoClose});
}

/// Options for [FSFileHandle.readFile] and [FSFileHandle.writeFile].
extension type _ReadWriteFileOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external AbortSignal? signal;

  external _ReadWriteFileOptions({String? encoding, AbortSignal? signal});
}
