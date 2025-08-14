// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:async/async.dart';
import 'package:js_core/js_core.dart';

import '../../fs.dart';
import '../stream/writable.dart';

/// The Node.js [`fs.WriteStream`] type.
///
/// [`fs.WriteStream`]: https://nodejs.org/docs/latest/api/fs.html#class-fswritestream
extension type FSWriteStream._(NodeWritable _) implements NodeWritable {
  /// Returns whether [value] is an instance of [FSWriteStream].
  static bool isA(JSAny? value) => value.instanceof(fs.writeStreamClass);

  /// A Dart [CancelableOperation] wrapping [the `'close'` event].
  ///
  /// [the `'close'` event]: https://nodejs.org/docs/latest/api/fs.html#event-close_3
  CancelableOperation<void> get onClose =>
      onceAsCancelableOperation('close'.toJS).then((_) {});

  /// A Dart [CancelableOperation] wrapping [the `'open'` event].
  ///
  /// [the `'open'` event]: https://nodejs.org/docs/latest/api/fs.html#event-open_1
  CancelableOperation<int> get onOpen =>
      onceAsCancelableOperation<JSNumber>('open'.toJS)
          .then((args) => args[0].toDartInt);

  /// A Dart [CancelableOperation] wrapping [the `'ready'` event].
  ///
  /// [the `'ready'` event]: https://nodejs.org/docs/latest/api/fs.html#event-ready_1
  CancelableOperation<void> get onReady =>
      onceAsCancelableOperation('ready'.toJS).then((_) {});

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#writestreambyteswritten
  external int get bytesWritten;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#writestreampath
  ///
  /// This will be either a [JSString] or a [Buffer].
  external JSAny get path;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#writestreampending
  external bool? get pending;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#writestreamclosecallback
  JSPromise<Null> close() => JSPromise((JSFunction resolve, JSFunction reject) {
        _close((JSError? error) {
          if (error == null) {
            resolve.callAsFunction();
          } else {
            reject.callAsFunction(null, error);
          }
        }.toJS);
      }.toJS);

  @JS('close')
  external void _close(JSFunction callback);
}
