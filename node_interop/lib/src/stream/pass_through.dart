// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'duplex.dart';

/// The Node.js `PassThrough` stream.
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('stream.PassThrough')
extension type NodePassThrough<T extends JSAny>.__(NodeDuplex _)
    implements NodeDuplex {
  external NodePassThrough();
}
