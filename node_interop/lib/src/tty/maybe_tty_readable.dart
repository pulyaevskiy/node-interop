// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../buffer/buffer.dart';
import '../stream/readable.dart';
import 'read_stream.dart';

/// A [NodeReadable] that may or may not also be a [TtyReadStream].
///
/// This exposes an [isTty] getter that's `true` if this is a [TtyReadStream]
/// and `false` otherwise. For convenience, in Dart we also expose [asTty] which
/// returns this as a `TtyReadStream`?.
@anonymous
extension type MaybeTtyReadable._(NodeReadable<Buffer> _)
    implements NodeReadable<Buffer> {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#readstreamistty
  bool get isTty => _isTty ?? false;

  @JS('isTTY')
  external bool? get _isTty;

  /// If [isTty] returns `true`, returns this cast to a [TtyReadStream].
  ///
  /// Otherwise, returns `null`.
  TtyReadStream? get asTty => isTty ? this as TtyReadStream : null;
}
