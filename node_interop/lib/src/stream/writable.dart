// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:async/async.dart';
import 'package:web/web.dart';

import 'module.dart';
import 'readable.dart';
import 'stream.dart';

/// The Node.js `Writable` stream.
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('stream.Writable')
extension type NodeWritable<T extends JSAny>.__(NodeStream _)
    implements NodeStream {
  /// A broadcast stream wrapping [the `'drain'` event].
  ///
  /// [the `'drain'` event]: https://nodejs.org/docs/latest/api/stream.html#event-drain
  Stream<void> get onDrain => eventAsVoidStream('drain'.toJS);

  /// A Dart [CancelableOperation] wrapping [the `'finish'` event].
  ///
  /// [the `'finish'` event]: https://nodejs.org/docs/latest/api/stream.html#event-finish
  CancelableOperation<void> get onFinish =>
      onceAsCancelableOperation('finish'.toJS).then((_) {});

  /// A broadcast stream wrapping [the `'pipe'` event].
  ///
  /// [the `'pipe'` event]: https://nodejs.org/docs/latest/api/stream.html#event-pipe
  Stream<NodeReadable> get onPipe => eventAsStream('pipe'.toJS);

  /// A broadcast stream wrapping [the `'unpipe'` event].
  ///
  /// [the `'unpipe'` event]: https://nodejs.org/docs/latest/api/stream.html#event-unpipe
  Stream<NodeReadable> get onUnpipe => eventAsStream('unpipe'.toJS);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamwritablefromwebwritablestream-options
  static NodeWritable<T> fromWeb<T extends JSAny>(WritableStream webStream,
      {bool? decodeStrings,
      int? highWaterMark,
      bool? objectMode,
      AbortSignal? signal}) {
    var options = _NewWritableOptions();
    if (decodeStrings != null) options.decodeStrings = decodeStrings;
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (objectMode != null) options.objectMode = objectMode;
    if (signal != null) options.signal = signal;
    return _fromWeb(webStream, options);
  }

  @JS('fromWeb')
  external static NodeWritable<T> _fromWeb<T extends JSAny>(
      WritableStream stream,
      [_NewWritableOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamwritabletowebstreamwritable
  @JS('toWeb')
  WritableStream toWeb() => _toWeb(this);

  @JS('toWeb')
  external static WritableStream _toWeb(NodeWritable stream);

  // TODO: Add extension methods to convert to and from Dart StreamSinks

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritable
  external bool get writable;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritableaborted
  external bool get writableAborted;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritableended
  external bool get writableEnded;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritablecorked
  external bool get writableCorked;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritablefinished
  external bool get writableFinished;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritablehighwatermark
  external int get writableHighWaterMark;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritablelength
  external int get writableLength;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritableneeddrain
  external bool get writableNeedDrain;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewritableobjectmode
  external bool get writableObjectModeobjectMode;

  factory NodeWritable(
      {int? highWaterMark,
      bool? decodeStrings,
      String? defaultEncoding,
      bool? objectMode,
      bool? emitClose,
      JSFunction? write,
      JSFunction? writev,
      JSFunction? destroy,
      JSFunction? finalize,
      JSFunction? construct,
      bool? autoDestroy,
      AbortSignal? signal}) {
    var options = _NewWritableOptions();
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (decodeStrings != null) options.decodeStrings = decodeStrings;
    if (defaultEncoding != null) options.defaultEncoding = defaultEncoding;
    if (objectMode != null) options.objectMode = objectMode;
    if (emitClose != null) options.emitClose = emitClose;
    if (write != null) options.write = write;
    if (writev != null) options.writev = writev;
    if (destroy != null) options.destroy = destroy;
    if (finalize != null) options.finalize = finalize;
    if (construct != null) options.construct = construct;
    if (autoDestroy != null) options.autoDestroy = autoDestroy;
    if (signal != null) options.signal = signal;
    return NodeWritable._(options);
  }

  external NodeWritable._([_NewWritableOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablecork
  external void cork();

  /// See [the Node.js documentation].
  ///
  /// This intentionally doesn't expose the `callback` option. Use [finished]
  /// instead to wait for the stream to finish writing.
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writableendchunk-encoding-callback
  external void end(T chunk, [String encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamfinishedstream-options
  JSPromise<Null> onFinished(
      {bool? error, bool? writable, AbortSignal? signal, bool? cleanup}) {
    var options = FinishedOptions();
    if (error != null) options.error = error;
    if (writable != null) options.writable = writable;
    if (signal != null) options.signal = signal;
    if (cleanup != null) options.cleanup = cleanup;
    return streamPromises.finished(this, options);
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablesetdefaultencodingencoding
  external void setDefaultEncoding(String encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writableuncork
  external void uncork();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewrite
  external void write(T chunk, [JSFunction callback]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writablewrite
  @JS('write')
  external void writeWithEncoding(T chunk, [JSFunction callback]);
}

/// Options for [NodeWritable.new].
@anonymous
extension type _NewWritableOptions._(JSObject _) implements JSObject {
  external int? highWaterMark;
  external bool? decodeStrings;
  external String? defaultEncoding;
  external bool? objectMode;
  external bool? emitClose;
  external JSFunction? write;
  external JSFunction? writev;
  external JSFunction? destroy;
  @JS('final')
  external JSFunction? finalize;
  external JSFunction? construct;
  external bool? autoDestroy;
  external AbortSignal? signal;

  external _NewWritableOptions();
}
