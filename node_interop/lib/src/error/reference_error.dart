// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

import 'new_error_options.dart';

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/api/errors.html#class-referenceerror
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('ReferenceError')
extension type NodeReferenceError.__(JSError _) implements JSError {
  /// See [`new Error()`].
  ///
  /// [`new Error()`]: https://nodejs.org/api/errors.html#new-errormessage-options
  factory NodeReferenceError(String message, {JSAny? cause}) => cause == null
      ? NodeReferenceError._(message)
      : NodeReferenceError._(message, NewErrorOptions(cause: cause));

  external NodeReferenceError._(String message, [NewErrorOptions options]);
}
