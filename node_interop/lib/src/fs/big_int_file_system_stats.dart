// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

/// The Node.js [`fs.StatsFs` object], with [JSBigInt] values.
///
/// [`fs.Stats` object]: https://nodejs.org/docs/latest/api/fs.html#class-fsstatfs
@anonymous
extension type FSBigIntFileSystemStats._(JSObject _) implements JSObject {
  external JSBigInt get type;
  external JSBigInt get bsize;
  external JSBigInt get blocks;
  external JSBigInt get bfree;
  external JSBigInt get bavail;
  external JSBigInt get files;
  external JSBigInt get ffree;
}
