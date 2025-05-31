// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:js_core/unsafe.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart';

import '../abort_signal_options.dart';

// Normally this would be in lib/events.dart, but we have to have it here to
// work around dart-lang/sdk#60772.
@anonymous
extension type EventsModule._(JSObject _) implements JSObject {
  /// @nodoc
  @internal
  external JSClass get EventEmitter;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsdefaultmaxlisteners
  external int get defaultMaxListeners;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventserrormonitor
  external JSSymbol get errorMonitor;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventscapturerejections
  external bool captureRejections;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventscapturerejectionsymbol
  external JSSymbol get captureRejectionSymbol;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventssetmaxlistenersn-eventtargets
  set maxListeners(int value) => setMaxListeners(value);

  /// @nodoc
  @internal
  external JSArray<JSFunction> getEventListeners(
      JSObject target, JSAny eventName);

  /// @nodoc
  @internal
  external int getMaxListeners(JSObject target);

  /// @nodoc
  @internal
  @JS('once')
  external JSPromise<JSArray<T>> _once<T extends JSAny?>(
      JSObject target, JSAny eventName,
      [AbortSignalOptions options]);

  /// @nodoc
  @internal
  JSPromise<JSArray<T>> once<T extends JSAny?>(JSObject target, JSAny eventName,
          {AbortSignal? signal}) =>
      signal == null
          ? _once(target, eventName)
          : _once(target, eventName, AbortSignalOptions(signal: signal));

  /// @nodoc
  @internal
  @JS('on')
  external JSAsyncIterator<JSArray<T>> _on<T extends JSAny?>(
      // Note: the target is only documented as being an `EventEmitter`, but it
      // works with `EventTarget`s as well.
      JSObject target,
      JSAny eventName,
      [OnOptions options]);

  /// @nodoc
  @internal
  JSAsyncIterator<JSArray<T>> on<T extends JSAny?>(
      // Note: the target is only documented as being an `EventEmitter`, but it
      // works with `EventTarget`s as well.
      JSObject target,
      JSAny eventName,
      {AbortSignal? signal,
      List<String>? close,
      int? highWaterMark,
      int? lowWaterMark}) {
    var options = OnOptions();
    if (signal != null) options.signal = signal;
    if (close != null) options.close = close.toJS;
    if (highWaterMark != null) options.highWaterMark = highWaterMark;
    if (lowWaterMark != null) options.lowWaterMark = lowWaterMark;
    return _on(target, eventName, options);
  }

  /// @nodoc
  @internal
  external void setMaxListeners(int value, [JSObject target]);

  /// @nodoc
  @internal
  external Disposable addAbortListener(AbortSignal signal, JSFunction listener);
}

/// @nodoc
@internal
@anonymous
extension type OnOptions._(JSObject _) implements JSObject {
  external AbortSignal? signal;
  external JSArray<JSString>? close;
  external int? highWaterMark;
  external int? lowWaterMark;

  external OnOptions(
      {AbortSignal? signal,
      JSArray<JSString>? close,
      int? highWaterMark,
      int? lowWaterMark});
}
