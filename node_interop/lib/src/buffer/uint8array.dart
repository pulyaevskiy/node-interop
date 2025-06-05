// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'buffer.dart';

@JS('buffer.transcode')
external Buffer _transcode(JSUint8Array source, String fromEnc, String toEnc);

/// Node.js-specific extensions on the standard [JSUint8Array] class.
extension JSUint8ArrayExtension on JSUint8Array {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#buffertranscodesource-fromenc-toenc
  Buffer transcode(String fromEnc, String toEnc) =>
      _transcode(this, fromEnc, toEnc);
}
