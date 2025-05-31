// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:meta/meta.dart';
import 'package:web/web.dart';

import 'duplex.dart';
import 'stream.dart';

@JS('stream.promises')
@internal
external StreamPromisesModule get streamPromises;

@anonymous
extension type StreamModule._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streampipelinesource-transforms-destination-options
  JSPromise<Null> pipeline(List<JSAny> streams,
      {AbortSignal? signal, bool? end}) {
    var options = _PipelineOptions();
    if (signal != null) options.signal = signal;
    if (end != null) options.end = end;
    return streamPromises.pipeline(streams.toJS, options);
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamduplexpairoptions
  (NodeDuplex<T>, NodeDuplex<T>) duplexPair<T extends JSAny>(
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

    var array = _duplexPair<T>(options);
    return (array[0], array[1]);
  }

  @JS('duplexPair')
  external JSArray<NodeDuplex<T>> _duplexPair<T extends JSAny>(
      [NewDuplexOptions options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamgetdefaulthighwatermarkobjectmode
  external int getDefaaultHighWaterMark(bool objectMode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamsetdefaulthighwatermarkobjectmode-value
  external void setDefaaultHighWaterMark(bool objectMode, int value);
}

@anonymous
@internal
extension type StreamPromisesModule._(JSObject _) implements JSObject {
  external JSPromise<Null> pipeline(JSArray<JSAny> streams,
      [_PipelineOptions options]);
  external JSPromise<Null> finished(NodeStream stream,
      [FinishedOptions options]);
}

/// Options for [StreamModule.pipeline].
///
/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streampipelinestreams-options
@anonymous
extension type _PipelineOptions._(JSObject _) implements JSObject {
  external AbortSignal? signal;
  external bool? end;

  external _PipelineOptions();
}

/// Options for [StreamModule.finished].
///
/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamfinishedstream-options
@anonymous
@internal
extension type FinishedOptions._(JSObject _) implements JSObject {
  external bool? error;
  external bool? readable;
  external bool? writable;
  external AbortSignal? signal;
  external bool? cleanup;

  external FinishedOptions(
      {bool? error,
      bool? readable,
      bool? writable,
      AbortSignal? signal,
      bool? cleanup});
}
