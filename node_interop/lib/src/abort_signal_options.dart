// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:meta/meta.dart';
import 'package:web/web.dart';

/// An options object that only passes an [AbortSignal].
///
/// There are a number of APIs that only take this single options.
@internal
extension type AbortSignalOptions._(JSObject _) implements JSObject {
  external AbortSignal? signal;

  external AbortSignalOptions({AbortSignal? signal});
}
