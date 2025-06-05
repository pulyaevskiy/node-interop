// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

extension BlobNodeJSExtensions on Blob {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#blobbytes
  external JSPromise<JSUint8Array> bytes();
}
