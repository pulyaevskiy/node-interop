// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';

import 'package:js_core/js_core.dart';

import '../../fs.dart';

/// The Node.js [`fs.Dir`] type.
///
/// [`fs.Dir`]: https://nodejs.org/docs/latest/api/fs.html#class-fsdir
extension type FSDir._(JSObject _)
    implements JSAsyncIterable, AsyncDisposable, Disposable {
  /// Returns whether [value] is an instance of this type.
  static bool isA(JSAny? value) => value.instanceof(fs.dirClass);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#dirpath
  external String get path;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#dirclose
  external JSPromise<Null> close();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#dirclosesync
  external void closeSync();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#dirread
  external JSPromise<FSDirEntry?> read();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#dirreadsync
  external FSDirEntry? readSync();

  /// Runs [callback] and disposes of [this] asynchronously after it completes
  /// (even if it produces an error).
  ///
  /// If [callback] returns a `Future`, [this] is instead disposed after that
  /// future completes.
  Future<T> using<T>(FutureOr<T> Function() callback) =>
      (this as AsyncDisposable).using(callback);

  /// Runs [callback] and disposes of [this] synchronously after it completes
  /// (even if it produces an error).
  T usingSync<T>(T Function() callback) => (this as Disposable).using(callback);
}
