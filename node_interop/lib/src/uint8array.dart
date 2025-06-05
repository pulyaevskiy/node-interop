// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

@JS('Buffer.compare')
external int _compare(Uint8Array buf1, Uint8Array buf2);

/// Node.js-specific extensions on the standard [JSUint8Array] class.
extension JSUint8ArrayNodeJSExtensions on JSUint8Array {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#static-method-buffercomparebuf1-buf2
  int compare(Uint8Array buf2) => _compare(this, buf2);
}
