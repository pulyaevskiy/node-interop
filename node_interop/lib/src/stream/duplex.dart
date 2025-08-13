// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart';

import 'module.dart';
import 'stream.dart';
import 'readable.dart';
import 'writable.dart';

/// The Node.js `Duplex` stream.
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('stream.Duplex')
extension type NodeDuplex<T extends JSAny>.__(NodeStream _)
    implements NodeReadable, NodeWritable {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#duplexallowhalfopen
  external bool get disallowHalfOpen;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamfinishedstream-options
  JSPromise<Null> onFinished(
      {bool? error,
      bool? writable,
      bool? readable,
      AbortSignal? signal,
      bool? cleanup}) {
    var options = FinishedOptions();
    if (error != null) options.error = error;
    if (writable != null) options.writable = writable;
    if (readable != null) options.readable = readable;
    if (signal != null) options.signal = signal;
    if (cleanup != null) options.cleanup = cleanup;
    return streamPromises.finished(this, options);
  }

  // TODO: Add a wrapper to expose this as a Dart StreamChannel.

  factory NodeDuplex(
      {bool? allowHalfOpen,
      bool? readable,
      bool? writable,
      bool? readableObjectMode,
      bool? writableObjectMode,
      bool? readableHighWaterMark,
      bool? writableHighWaterMark}) {
    var options = NewDuplexOptions();
    if (allowHalfOpen != null) options.allowHalfOpen = allowHalfOpen;
    if (readable != null) options.readable = readable;
    if (writable != null) options.writable = writable;
    if (readableObjectMode != null) {
      options.readableObjectMode = readableObjectMode;
    }
    if (writableObjectMode != null) {
      options.writableObjectMode = writableObjectMode;
    }
    if (readableHighWaterMark != null) {
      options.readableHighWaterMark = readableHighWaterMark;
    }
    if (writableHighWaterMark != null) {
      options.writableHighWaterMark = writableHighWaterMark;
    }
    return NodeDuplex._(options);
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  external static NodeDuplex<T> from<T extends JSAny>(JSAny src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromReadable<T extends JSAny>(NodeReadable<T> src) =>
      from(src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromWritable<T extends JSAny>(NodeWritable<T> src) =>
      from(src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromArray<T extends JSAny>(JSArray<T> src) => from(src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromIterable<T extends JSAny>(JSIterable<T> src) =>
      from(src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromAsyncIterable<T extends JSAny>(
          JSAsyncIterable<T> src) =>
      from(src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromPair<T extends JSAny>(
          NodeReadable<T> readable, NodeWritable<T> writable) =>
      from(_FromPairOptions(readable: readable, writable: writable));

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromsrc
  static NodeDuplex<T> fromPromise<T extends JSAny>(JSPromise<T> src) =>
      from(src);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexfromwebpair-options
  static NodeDuplex<T> fromWeb<T extends JSAny>(
      ReadableStream readable, WritableStream writable,
      {bool? allowHalfOpen,
      bool? decodeStrings,
      String? encoding,
      int? highWaterMark,
      bool? objectMode,
      AbortSignal? signal}) {
    var options = _FromWebOptions();
    if (allowHalfOpen != null) options.allowHalfOpen = allowHalfOpen;
    if (decodeStrings != null) options.decodeStrings = decodeStrings;
    if (encoding != null) options.encoding = encoding;
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (objectMode != null) options.objectMode = objectMode;
    if (signal != null) options.signal = signal;
    return _fromWeb(
        _FromWebPair(readable: readable, writable: writable), options);
  }

  @JS('fromWeb')
  external static NodeDuplex<T> _fromWeb<T extends JSAny>(_FromWebPair pair,
      [_FromWebOptions options]);

  external NodeDuplex._(NewDuplexOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplextowebstreamduplex
  (ReadableStream, WritableStream) toWeb() {
    var result = _toWeb(this);
    return (result.readable, result.writable);
  }

  @JS('toWeb')
  external static _ToWebResult _toWeb(NodeDuplex duplex);
}

/// Options for [NodeDuplex.new].
@anonymous
@internal
extension type NewDuplexOptions._(JSObject _) implements JSObject {
  external bool? allowHalfOpen;
  external bool? readable;
  external bool? writable;
  external bool? readableObjectMode;
  external bool? writableObjectMode;
  external bool? readableHighWaterMark;
  external bool? writableHighWaterMark;

  // TODO - dart-lang/sdk#61309: Remove this parameter.
  external NewDuplexOptions({Null x});
}

/// Options for [NodeDuplex.fromWeb].
@anonymous
extension type _FromWebOptions._(JSObject _) implements JSObject {
  external bool? allowHalfOpen;
  external bool? decodeStrings;
  external String? encoding;
  external int? highWaterMark;
  external bool? objectMode;
  external AbortSignal? signal;

  external _FromWebOptions();
}

/// Options for [NodeDuplex.fromPair].
@anonymous
extension type _FromPairOptions._(JSObject _) implements JSObject {
  external NodeReadable readable;
  external NodeWritable writable;

  external _FromPairOptions(
      {required NodeReadable readable, required NodeWritable writable});
}

/// The pair object for [NodeDuplex.fromWeb].
@anonymous
extension type _FromWebPair._(JSObject _) implements JSObject {
  external ReadableStream readable;
  external WritableStream writable;

  external _FromWebPair(
      {required ReadableStream readable, required WritableStream writable});
}

/// The return value of [NodeDuplex._toWeb].
@anonymous
extension type _ToWebResult._(JSObject _) implements JSObject {
  external ReadableStream get readable;
  external WritableStream get writable;
}
