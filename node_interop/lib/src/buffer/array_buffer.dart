// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

@JS('buffer.isAscii')
external bool _isAscii(JSArrayBuffer input);

/// Node.js-specific extensions on the standard [JSArrayBuffer] class.
extension JSArrayBufferExtension on JSArrayBuffer {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferisasciiinput
  bool isAscii() => _isAscii(this);
}
