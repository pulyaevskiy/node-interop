// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

import '../../events.dart';

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
      events.getEventListeners(this, eventName).toDart;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsgetmaxlistenersemitterortarget
  int get maxListeners => events.getMaxListeners(this);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/v22.15.1/api/events.html#eventssetmaxlistenersn-eventtargets
  set maxListeners(int value) => events.setMaxListenersOn(value, this);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/v22.15.1/api/events.html#eventsonceemitter-name-options
  JSAsyncIterator<JSArray<T>> onAsIterator<T extends JSAny?>(JSAny eventName,
          {AbortSignal? signal,
          JSArray<String>? close,
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
      events.once(this, eventName, signal: signal);
}
