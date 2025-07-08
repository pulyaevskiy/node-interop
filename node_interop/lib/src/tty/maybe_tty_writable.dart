// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../stream/writable.dart';
import 'write_stream.dart';

/// A [NodeWritable] that may or may not also be a [TtyWriteStream].
///
/// This exposes an [isTty] getter that's `true` if this is a [TtyWriteStream]
/// and `false` otherwise. For convenience, in Dart we also expose [asTty] which
/// returns this as a `TtyWriteStream`?.
@anonymous
extension type MaybeTtyWritable<T extends JSAny>._(NodeWritable<T> _)
    implements NodeWritable<T> {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamistty
  @JS('isTTY')
  bool get isTty => _isTty ?? false;

  @JS('isTTY')
  external bool? get _isTty;

  /// If [isTty] returns `true`, returns this cast to a [TtyWriteStream].
  ///
  /// Otherwise, returns `null`.
  TtyWriteStream? get asTty => isTty ? this as TtyWriteStream : null;
}
