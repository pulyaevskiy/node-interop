// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

/// The Node.js [`fs.StatsFs` object], with integer values.
///
/// [`fs.Stats` object]: https://nodejs.org/docs/latest/api/fs.html#class-fsstatfs
@anonymous
extension type FSFileSystemStats._(JSObject _) implements JSObject {
  external int get type;
  external int get bsize;
  external int get blocks;
  external int get bfree;
  external int get bavail;
  external int get files;
  external int get ffree;
}
