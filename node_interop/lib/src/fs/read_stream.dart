// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:async/async.dart';

import '../../fs.dart';
import '../stream/readable.dart';

/// The Node.js [`fs.ReadStream`] type.
///
/// [`fs.ReadStream`]: https://nodejs.org/docs/latest/api/fs.html#class-fsreadstream
@anonymous
extension type FSReadStream._(NodeReadable _) implements NodeReadable {
  /// Returns whether [value] is an instance of [FSReadStream].
  static bool isA(JSAny? value) => value.instanceof(fs.readStreamClass);

  /// A Dart [CancelableOperation] wrapping [the `'close'` event].
  ///
  /// [the `'close'` event]: https://nodejs.org/docs/latest/api/fs.html#event-close_2
  CancelableOperation<void> get onClose =>
      onceAsCancelableOperation('close'.toJS).then((_) {});

  /// A Dart [CancelableOperation] wrapping [the `'open'` event].
  ///
  /// [the `'open'` event]: https://nodejs.org/docs/latest/api/fs.html#event-open
  CancelableOperation<int> get onOpen =>
      onceAsCancelableOperation<JSNumber>('open'.toJS)
          .then((args) => args[0].toDartInt);

  /// A Dart [CancelableOperation] wrapping [the `'ready'` event].
  ///
  /// [the `'ready'` event]: https://nodejs.org/docs/latest/api/fs.html#event-ready
  CancelableOperation<void> get onReady =>
      onceAsCancelableOperation('ready'.toJS).then((_) {});

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#readstreambytesread
  external int get bytesRead;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#readstreampath
  ///
  /// If this isn't null, it will be either a [JSString] or a [Buffer].
  external JSAny? get path;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#readstreampending
  external bool? get pending;
}
