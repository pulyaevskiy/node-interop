// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

@JS('buffer.isAscii')
external bool _isAscii(JSTypedArray input);

@JS('buffer.isUtf8')
external bool _isUtf8(JSTypedArray input);

/// Node.js-specific extensions on the standard [JSTypedArray] class.
extension JSTypedArrayExtension on JSTypedArray {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferisasciiinput
  bool isAscii() => _isAscii(this);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferisutf8input
  bool isUtf8() => _isUtf8(this);
}
