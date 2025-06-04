// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

import '../../node_interop.dart';
import '../abort_signal_options.dart';

@JS('events.getEventListeners')
external JSArray<JSFunction> _getEventListeners(
    EventTarget target, JSAny eventName);

@JS('events.getMaxListeners')
external int _getMaxListeners(EventTarget target);

@JS('events.setMaxListeners')
external void _setMaxListeners(int value, EventTarget target);

@JS('events.once')
external JSPromise<JSArray<T>> _once<T extends JSAny?>(
    EventTarget target, JSAny eventName,
    [AbortSignalOptions options]);

/// Node.js-specific extensions on the standard [EventTarget] class.
///
/// See also [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventtarget-and-event-api
extension EventTargetNodeJSExtensions on EventTarget {
  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsgeteventlistenersemitterortarget-eventname
  List<JSFunction> listeners(JSAny eventName) =>
      _getEventListeners(this, eventName).toDart;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsgetmaxlistenersemitterortarget
  int get maxListeners => _getMaxListeners(this);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/v22.15.1/api/events.html#eventssetmaxlistenersn-eventtargets
  set maxListeners(int value) => _setMaxListeners(value, this);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/v22.15.1/api/events.html#eventsonceemitter-name-options
  JSAsyncIterator<JSArray<T>> onAsIterator<T extends JSAny?>(JSAny eventName,
          {AbortSignal? signal,
          List<String>? close,
          int? highWaterMark,
          int? lowWaterMark}) =>
      events.on(this, eventName,
          signal: signal,
          close: close,
          highWaterMark: highWaterMark,
          lowWaterMark: lowWaterMark);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/v22.15.1/api/events.html#eventsonceemitter-name-options
  JSPromise<JSArray<T>> onceAsPromise<T extends JSAny?>(JSAny eventName,
          {AbortSignal? signal}) =>
      signal == null
          ? _once(this, eventName)
          : _once(this, eventName, AbortSignalOptions(signal: signal));
}
