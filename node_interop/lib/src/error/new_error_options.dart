// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:meta/meta.dart';

/// The options type for error constructors.
@internal
extension type NewErrorOptions._(JSObject _) implements JSObject {
  external JSAny? cause;

  external NewErrorOptions({JSAny? cause});
}
