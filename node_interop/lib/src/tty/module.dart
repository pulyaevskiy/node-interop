// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/unsafe.dart';
import 'package:meta/meta.dart';

import 'read_stream.dart';

// Normally this would be in lib/fs.dart, but we have to have it here to
// work around dart-lang/sdk#60772.
/// The Node.js [`tty` module].
///
/// [`tty` module]: https://nodejs.org/docs/latest/api/tty.html
@anonymous
extension type TtyModule._(JSObject _) implements JSObject {
  /// @nodoc
  @internal
  @JS('ReadStream')
  external JSClass<TtyReadStream> get readStreamClass;

  /// @nodoc
  @internal
  @JS('WriteStream')
  external JSClass<TtyReadStream> get writeStreamClass;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#ttyisattyfd
  @JS('isatty')
  external bool isTty(int fd);
}
