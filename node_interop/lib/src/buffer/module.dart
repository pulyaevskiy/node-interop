// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:web/web.dart';

@JS('buffer')
external BufferModule get buffer;

extension type BufferModule._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferinspect_max_bytes
  @JS('INSPECT_MAX_BYTES')
  external int inspectMaxBytes;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferconstantsmax_length
  @JS('kMaxLength')
  external int get maxLength;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferconstantsmax_string_length
  @JS('kStringMaxLength')
  external int get maxStringLength;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#bufferresolveobjecturlid
  external Blob resolveObjectURL(String id);
}
