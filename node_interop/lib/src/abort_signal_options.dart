// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:web/web.dart';

/// An options object that only passes an [AbortSignal].
///
/// There are a number of APIs that only take this single options.
@abstract
extension type AbortSignalOptions._(JSObject _) implements JSObject {
  external AbortSignal? signal;

  AbortSignalOptions({AbortSignal? signal});
}
