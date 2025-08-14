// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:async/async.dart';
import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

import '../../node_interop.dart';
import '../abort_signal_options.dart';

@JS('events.once')
external JSPromise<JSArray<T>> _once<T extends JSAny?>(
    EventEmitter target, JSAny eventName,
    [AbortSignalOptions options]);

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#class-eventemitter
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('events.EventEmitter')
extension type EventEmitter.__(JSObject _) implements JSObject {
  /// A Dart broadcast stream wrapping [the `'newListener'` event].
  ///
  /// [the `'newListener'` event]: https://nodejs.org/docs/latest/api/events.html#event-newlistener
  Stream<(JSAny eventName, JSFunction listener)> get onNewListener =>
      eventAsStreamPair('onNewListener'.toJS);

  /// A Dart broadcast stream wrapping [the `'removeListener'` event].
  ///
  /// [the `'removeListener'` event]: https://nodejs.org/docs/latest/api/events.html#event-removelistener
  Stream<(JSAny eventName, JSFunction listener)> get onRemoveListener =>
      eventAsStreamPair('onRemoveListener'.toJS);

  /// Creates a new [EventEmitter].
  factory EventEmitter({bool captureRejections = false}) => captureRejections
      ? EventEmitter._(_EventEmitterConstructorOptions(captureRejections: true))
      : EventEmitter._();

  external EventEmitter._([_EventEmitterConstructorOptions options]);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitteremiteventname-args
  external bool emit(JSAny eventName,
      [JSAny? arg1, JSAny? arg2, JSAny? arg3, JSAny? arg4]);

  /// Like [emit], but passes all of [args] to the event.
  bool emitVarArgs(JSAny eventName, [List<JSAny?>? args]) =>
      callMethodVarArgs('emit'.toJS, [eventName, ...?args]);

  @JS('eventNames')
  external JSArray<JSAny> _eventNames();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emittereventnames
  List<JSAny> get eventNames => _eventNames().toDart;

  @JS('getMaxListeners')
  external int _getMaxListeners();
  @JS('setMaxListeners')
  external void _setMaxListeners(int value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emittergetmaxlisteners
  int get maxListeners => _getMaxListeners();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emittersetmaxlisteners
  set maxListeners(int value) => _setMaxListeners(value);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterlistenercount
  external int listenerCount(JSAny eventName, [JSFunction listener]);

  @JS('listeners')
  external JSArray<JSFunction> _listeners(JSAny eventName);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterlisteners
  List<JSFunction> listeners(JSAny eventName) => _listeners(eventName).toDart;

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitteron
  external void on(JSAny eventName, JSFunction listener);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsonceemitter-name-options
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
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitteronce
  external void once(JSAny eventName, JSFunction listener);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsonceemitter-name-options
  JSPromise<JSArray<T>> onceAsPromise<T extends JSAny?>(JSAny eventName,
          {AbortSignal? signal}) =>
      signal == null
          ? _once(this, eventName)
          : _once(this, eventName, AbortSignalOptions(signal: signal));

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterprependlistener
  external void prependListener(JSAny eventName, JSFunction listener);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterprependoncelistener
  external void prependOnceListener(JSAny eventName, JSFunction listener);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterremovealllisteners
  external void removeAllListeners([JSAny eventName]);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterremovelistener
  external void removeListener(JSAny eventName, JSFunction listener);

  /// See [the Node.js documentation].
  ///
  /// The [eventName] must be a [JSString] or a [JSSymbol].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#emitterrawlisteners
  external JSArray<JSFunction> rawListeners(JSAny eventName);

  /// Returns a Dart broadcast stream that emits an event for each [eventName]
  /// emitted by this emitter.
  ///
  /// This returns a stream that emits the first argument passed to the event
  /// function. See also [eventAsStreamPair], [eventAsStreamList], and
  /// [eventAsVoidStream].
  ///
  /// The event is registered once the stream has any listeners and unregistered
  /// once there are no more listeners.
  Stream<E> eventAsStream<E extends JSAny?>(JSAny eventName) {
    // TODO: Add a proper wrapper class for these.
    late StreamController<E> controller;
    var callback = (E arg) {
      controller.add(arg);
    }.toJS;

    controller = StreamController.broadcast(
        onListen: () => on(eventName, callback),
        onCancel: () => removeListener(eventName, callback),
        sync: true);
    return controller.stream;
  }

  /// Returns a Dart broadcast stream that emits an event for each [eventName]
  /// emitted by this emitter.
  ///
  /// This returns a stream that emits the first two arguments passed to the
  /// event function as a Dart tuple. See also [eventAsStream],
  /// [eventAsStreamList], and [eventAsVoidStream].
  ///
  /// The event is registered once the stream has any listeners and unregistered
  /// once there are no more listeners.
  Stream<(E1, E2)> eventAsStreamPair<E1 extends JSAny?, E2 extends JSAny?>(
      JSAny eventName) {
    late StreamController<(E1, E2)> controller;
    var callback = (E1 arg1, E2 arg2) {
      controller.add((arg1, arg2));
    }.toJS;

    controller = StreamController.broadcast(
        onListen: () => on(eventName, callback),
        onCancel: () => removeListener(eventName, callback),
        sync: true);
    return controller.stream;
  }

  /// Returns a Dart broadcast stream that emits an event for each [eventName]
  /// emitted by this emitter.
  ///
  /// Each event's value is the list of arguments passed to the JS event. See
  /// also [eventAsStream], [eventAsStreamPair], and [eventAsVoidStream].
  ///
  /// The event is registered once the stream has any listeners and unregistered
  /// once there are no more listeners.
  Stream<List<JSAny?>> eventAsStreamList(JSAny eventName) {
    late StreamController<List<JSAny?>> controller;
    var callback = (JSArray<JSAny?> args) {
      controller.add(args.toDart);
    }.toJSVarArgs;

    controller = StreamController.broadcast(
        onListen: () => on(eventName, callback),
        onCancel: () => removeListener(eventName, callback),
        sync: true);
    return controller.stream;
  }

  /// Returns a Dart broadcast stream that emits an event for each [eventName]
  /// emitted by this emitter.
  ///
  /// Each event's value is void, for events that emit no additional information
  /// beyond the fact that something happened. See also [eventAsStream],
  /// [eventAsStreamPair], and [eventAsStreamList].
  ///
  /// The event is registered once the stream has any listeners and unregistered
  /// once there are no more listeners.
  Stream<void> eventAsVoidStream<E extends JSAny?>(JSAny eventName) {
    late StreamController<void> controller;
    var callback = (E arg) {
      controller.add(arg);
    }.toJS;

    controller = StreamController.broadcast(
        onListen: () => on(eventName, callback),
        onCancel: () => removeListener(eventName, callback),
        sync: true);
    return controller.stream;
  }

  /// Returns a Dart [CancelcableOperation] that completes with the arguments
  /// the next time [eventName] is emitted by this emitter.
  ///
  /// This converts cancellations on the operation into an [AbortSignal] that
  /// removes the underlying event listener.
  CancelableOperation<JSArray<T>> onceAsCancelableOperation<T extends JSAny?>(
      JSAny eventName) {
    var controller = AbortController();
    return CancelableOperation.fromFuture(
        onceAsPromise<T>(eventName, signal: controller.signal).toDart,
        onCancel: () => controller.abort());
  }
}

extension type _EventEmitterConstructorOptions._(JSObject _)
    implements JSObject {
  external _EventEmitterConstructorOptions({bool captureRejections});

  external bool captureRejections;
}
