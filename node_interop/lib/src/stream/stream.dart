// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:async/async.dart';
import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

import '../events/event_emitter.dart';

@JS('stream.addAbortSignal')
external void _addAbortSignal(AbortSignal signal, NodeStream stream);

/// The Node.js `Stream` base class.
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('stream.Stream')
extension type NodeStream._(JSObject _)
    implements JSObject, AsyncDisposable, EventEmitter {
  /// A Dart [CancelableOperation] wrapping [the `'close'` event].
  ///
  /// [the `'close'` event]: https://nodejs.org/docs/latest/api/stream.html#event-close
  CancelableOperation<void> get onClose =>
      onceAsCancelableOperation('close'.toJS).then((_) {});

  /// A Dart [CancelableOperation] wrapping [the `'error'` event].
  ///
  /// [the `'error'` event]: https://nodejs.org/docs/latest/api/stream.html#event-error
  CancelableOperation<JSError> get onError =>
      onceAsCancelableOperation('error'.toJS)
          .then((args) => args[0] as JSError);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writableclosed
  external bool get closed;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writabledestroyed
  external bool get destroyed;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writableerrored
  external JSError get errored;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#writabledestroyerror
  external void destroy([JSError error]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamaddabortsignalsignal-stream
  void addAbortSignal(AbortSignal signal) => _addAbortSignal(signal, this);
}
