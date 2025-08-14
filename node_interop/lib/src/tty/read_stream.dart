// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../../tty.dart';

// TODO: Extend `net.Socket` once we add typings for it
/// The Node.js [`tty.ReadStream` class].
///
/// [`tty.ReadStream` class]: https://nodejs.org/api/tty.html#class-ttyreadstream
extension type TtyReadStream._(MaybeTtyReadable _) implements MaybeTtyReadable {
  /// Returns whether [value] is an instance of this type.
  static bool isA(JSAny? value) =>
      value.instanceof(tty.readStreamClass as JSFunction);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#readstreamisraw
  @JS('isRaw')
  external bool get rawMode;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#readstreamsetrawmodemode
  set rawMode(bool value) => _setRawMode(value);

  @JS('setRawmode')
  external void _setRawMode(bool value);

  // TODO: Add options once we add typings for `net.Socket`.
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#new-ttyreadstreamfd-options
  factory TtyReadStream(int fd) => tty.readStreamClass.construct(fd.toJS);
}
