// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

import 'new_error_options.dart';

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/api/errors.html#class-typeerror
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('TypeError')
extension type NodeTypeError.__(JSError _) implements JSError {
  /// See [`new Error()`].
  ///
  /// [`new Error()`]: https://nodejs.org/api/errors.html#new-errormessage-options
  factory NodeTypeError(String message, {JSAny? cause}) => cause == null
      ? NodeTypeError._(message)
      : NodeTypeError._(message, NewErrorOptions(cause: cause));

  external NodeTypeError._(String message, [NewErrorOptions options]);
}
