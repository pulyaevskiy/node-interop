// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

import '../abort_signal_options.dart';
import 'duplex.dart';
import 'module.dart';
import 'stream.dart';
import 'writable.dart';

/// The Node.js `Readable` stream.
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('stream.Readable')
extension type NodeReadable<T extends JSAny>.__(NodeStream _)
    implements NodeStream, JSAsyncIterable {
  /// Wraps [the `data` event] in a single-subscription Dart stream.
  ///
  /// This forwards pause and resume invocations from the Dart stream to the
  /// Node.js stream. If the [Stream] is listened to and then canceled, destroys
  /// this [NodeReadable].
  ///
  /// [the `data` event]: https://nodejs.org/docs/latest/api/stream.html#event-data
  ///
  /// **Note:** Although this may buffer data in the Dart stream, that behavior
  /// is not guaranteed and may change in the future.
  Stream<T> get toDartStream {
    // TODO: Add a proper wrapper class for this.
    late StreamController<T> controller;
    var onData = (T arg) {
      controller.add(arg);
    }.toJS;
    var onError = (JSError error) {
      controller.addError(error, StackTrace.fromString(error.stack));
    }.toJS;
    var onEnd = (JSAny? _) {
      controller.close();
    }.toJS;

    controller = StreamController(
        onListen: () {
          on('data'.toJS, onData);
          on('error'.toJS, onError);
          on('end'.toJS, onEnd);
        },
        onCancel: () {
          removeListener('data'.toJS, onData);
          removeListener('error'.toJS, onError);
          removeListener('end'.toJS, onEnd);
          destroy();
        },
        onPause: () => this.pause(),
        onResume: () => this.resume(),
        sync: true);
    return controller.stream;
  }

  /// A broadcast stream wrapping [the `'pause'` event].
  ///
  /// [the `'pause'` event]: https://nodejs.org/docs/latest/api/stream.html#event-pause
  Stream<NodeReadable> get onPause => eventAsStream('pause'.toJS);

  /// A broadcast stream wrapping [the `'readable'` event].
  ///
  /// [the `'readable'` event]: https://nodejs.org/docs/latest/api/stream.html#event-readable
  Stream<NodeReadable> get onReadable => eventAsStream('readable'.toJS);

  /// A broadcast stream wrapping [the `'resume'` event].
  ///
  /// [the `'resume'` event]: https://nodejs.org/docs/latest/api/stream.html#event-resume
  Stream<NodeReadable> get onResume => eventAsStream('resume'.toJS);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableispaused
  bool get paused => _isPaused();

  @JS('isPaused')
  external bool _isPaused();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablereadable
  external bool get readable;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableaborted
  external bool get readableAborted;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readabledidRead
  external bool get readableDidRead;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableencoding
  external String? get readableEncoding;

  /// See [the Node.js documentation].
  ///
  /// Note: setting this to null doesn't actually unset the encoding.
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablesetencoding
  set readableEncoding(String? value) {
    _setEncoding(value);
  }

  @JS('setEncoding')
  external void _setEncoding(String? value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableended
  external bool get readableEnded;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableflowing
  external bool get readableFlowing;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablehighwatermark
  external int get readableHighWaterMark;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablelength
  external int get readableLength;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableobjectmode
  external bool get readableObjectMode;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamreadableisdisturbedstream
  bool get isDisturbed => _isDisturbed(this);

  @JS('isDisturbed')
  external static bool _isDisturbed(NodeReadable stream);

  factory NodeReadable(
      {int? highWaterMark,
      String? encoding,
      bool? objectMode,
      bool? emitClose,
      JSFunction? read,
      JSFunction? destroy,
      JSFunction? construct,
      bool? autoDestroy,
      AbortSignal? signal}) {
    var options = _NewReadableOptions();
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (encoding != null) options.encoding = encoding;
    if (objectMode != null) options.objectMode = objectMode;
    if (emitClose != null) options.emitClose = emitClose;
    if (read != null) options.read = read;
    if (destroy != null) options.destroy = destroy;
    if (construct != null) options.construct = construct;
    if (autoDestroy != null) options.autoDestroy = autoDestroy;
    if (signal != null) options.signal = signal;
    return NodeReadable._(options);
  }

  external NodeReadable._([_NewReadableOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamreadablefromiterable-options
  static NodeReadable<T> from<T extends JSAny>(JSArray<T> array,
      {int? highWaterMark,
      String? encoding,
      bool? objectMode,
      bool? emitClose,
      JSFunction? read,
      JSFunction? destroy,
      JSFunction? construct,
      bool? autoDestroy,
      AbortSignal? signal}) {
    var options = _NewReadableOptions();
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (encoding != null) options.encoding = encoding;
    if (objectMode != null) options.objectMode = objectMode;
    if (emitClose != null) options.emitClose = emitClose;
    if (read != null) options.read = read;
    if (destroy != null) options.destroy = destroy;
    if (construct != null) options.construct = construct;
    if (autoDestroy != null) options.autoDestroy = autoDestroy;
    if (signal != null) options.signal = signal;
    return _from(array, options);
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamreadablefromiterable-options
  static NodeReadable<T> fromIterable<T extends JSAny>(JSIterable<T> iterable,
      {int? highWaterMark,
      String? encoding,
      bool? objectMode,
      bool? emitClose,
      JSFunction? read,
      JSFunction? destroy,
      JSFunction? construct,
      bool? autoDestroy,
      AbortSignal? signal}) {
    var options = _NewReadableOptions();
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (encoding != null) options.encoding = encoding;
    if (objectMode != null) options.objectMode = objectMode;
    if (emitClose != null) options.emitClose = emitClose;
    if (read != null) options.read = read;
    if (destroy != null) options.destroy = destroy;
    if (construct != null) options.construct = construct;
    if (autoDestroy != null) options.autoDestroy = autoDestroy;
    if (signal != null) options.signal = signal;
    return _from(iterable, options);
  }

  @JS('from')
  external static NodeReadable<T> _from<T extends JSAny>(JSAny iterable,
      [_NewReadableOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamreadablefromwebreadablestream-options
  static NodeReadable<T> fromWeb<T extends JSAny>(ReadableStream webStream,
      {int? highWaterMark,
      String? encoding,
      bool? objectMode,
      AbortSignal? signal}) {
    var options = _NewReadableOptions();
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (encoding != null) options.encoding = encoding;
    if (objectMode != null) options.objectMode = objectMode;
    if (signal != null) options.signal = signal;
    return _fromWeb(webStream, options);
  }

  @JS('fromWeb')
  external static NodeReadable<T> _fromWeb<T extends JSAny>(
      ReadableStream stream,
      [_NewReadableOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamreadabletowebstreamreadable-options
  @JS('toWeb')
  ReadableStream toWeb({QueuingStrategy? strategy}) => strategy == null
      ? _toWeb(this)
      : _toWeb(this, _NewReadableStreamOptions(strategy: strategy));

  @JS('toWeb')
  external static ReadableStream _toWeb(NodeReadable stream,
      [_NewReadableStreamOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablepause
  external void pause();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readabledestination
  NodeWritable<T> pipe(NodeWritable<T> destination, {bool? end}) => end == null
      ? _pipe(destination)
      : _pipe(destination, _PipeOptions(end: end));

  external NodeWritable<T> _pipe(NodeWritable<T> destination,
      [_PipeOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablereadsize
  external T read([int size]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableresume
  external void resume();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableunpipedestination
  external void unpipe([NodeWritable? destination]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableunshiftchunk-encoding
  external void unshift(T? chunk, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablewrapstream
  external void wrap(NodeReadable stream);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablecomposestream-options
  NodeDuplex compose(JSAny stream, {AbortSignal? signal}) => signal == null
      ? _compose(stream)
      : _compose(stream, AbortSignalOptions(signal: signal));

  @JS('compose')
  external NodeDuplex _compose(JSAny stream, [AbortSignalOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readableiteratoroptions
  JSAsyncIterator iterator(JSAny stream, {bool? destroyOnReturn}) =>
      destroyOnReturn == null
          ? _iterator(stream)
          : _iterator(
              stream, _IteratorOptions(destroyOnReturn: destroyOnReturn));

  @JS('iterator')
  external JSAsyncIterator _iterator(JSAny stream, [_IteratorOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#readablepushchunk-encoding
  external bool push(T chunk, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamfinishedstream-options
  JSPromise<Null> onFinished(
      {bool? error, bool? readable, AbortSignal? signal, bool? cleanup}) {
    var options = FinishedOptions();
    if (error != null) options.error = error;
    if (readable != null) options.readable = readable;
    if (signal != null) options.signal = signal;
    if (cleanup != null) options.cleanup = cleanup;
    return streamPromises.finished(this, options);
  }
}

/// Options for [NodeReadable.pipe].
@anonymous
extension type _PipeOptions._(JSObject _) implements JSObject {
  external bool? end;

  external _PipeOptions({bool? end});
}

/// Options for [NodeReadable.iterator].
@anonymous
extension type _IteratorOptions._(JSObject _) implements JSObject {
  external bool? destroyOnReturn;

  external _IteratorOptions({bool? destroyOnReturn});
}

/// Options for [NodeReadable.new].
@anonymous
extension type _NewReadableOptions._(JSObject _) implements JSObject {
  external int? highWaterMark;
  external String? encoding;
  external bool? objectMode;
  external bool? emitClose;
  external JSFunction? read;
  external JSFunction? destroy;
  external JSFunction? construct;
  external bool? autoDestroy;
  external AbortSignal? signal;

  external _NewReadableOptions();
}

/// Options for [NodeReadable.toWeb].
@anonymous
extension type _NewReadableStreamOptions._(JSObject _) implements JSObject {
  external QueuingStrategy? strategy;

  external _NewReadableStreamOptions({QueuingStrategy? strategy});
}
