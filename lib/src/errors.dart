// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:io' as io;

import 'bindings/globals.dart';
import 'bindings/net.dart';
import 'internet_address.dart';

/// Converts [error] originated in JavaScript in to a corresponding Dart
/// error on the best-effort basis.
///
/// Optional [originator] provides context for resolving IO specific errors
/// and must be an instance of native JS objects like [Socket].
dynamic dartifyError(JsError error, [originator]) {
  if (error is JsAssertionError) {
    return new AssertionError(error.message);
  } else if (error is JsRangeError) {
    return new RangeError(error.message);
  } else if (error is JsReferenceError) {
    return new StateError(error.message);
  } else if (error is JsSyntaxError) {
    return new StateError(error.message);
  } else if (error is JsTypeError) {
    return new ArgumentError(error.message);
  } else if (error is JsSystemError) {
    if (originator is Socket) {
      return new io.SocketException(
        error.message,
        osError: new io.OSError(error.message, error.errno),
        address: new InternetAddress(error.address),
        port: error.port,
      );
    }
    return new Exception(error.message);
  } else {
    return new Exception(error.message);
  }
}
