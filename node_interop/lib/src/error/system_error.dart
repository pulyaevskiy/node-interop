// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/api/errors.html#class-systemerror
@anonymous
extension type NodeSystemError.__(JSError _) implements JSError {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#erroraddress
  external String? get address;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errorcode_1
  external String get code;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errordest
  external String? get dest;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errorerrno
  @JS('errno')
  external int? get errorNumber;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errorinfo
  external JSRecord? get info;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errorpath
  external String? get path;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errorport
  external int? get port;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/errors.html#errorsyscall
  @JS('syscall')
  external String? get systemCall;
}
