// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:web/web.dart';

@JS('stream.isErrored')
external bool _isErrored(WritableStream stream);

@JS('stream.addAbortSignal')
external void _addAbortSignal(AbortSignal signal, WritableStream stream);

/// Node.js-specific extensions on the standard [WritableStream] class.
extension WritableStreamNodeJSExtensions on WritableStream {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamiserroredstream
  bool get isErrored => _isErrored(this);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/stream.html#streamaddabortsignalsignal-stream
  void addAbortSignal(AbortSignal signal) => _addAbortSignal(signal, this);
}
