// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

/// The Node.js [`fs.StatsFs` object], with [JSBigInt] values.
///
/// [`fs.Stats` object]: https://nodejs.org/docs/latest/api/fs.html#class-fsstatfs
@anonymous
extension type FSBigIntFileSystemStats._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfsbavail
  @JS('bavail')
  external JSBigInt get blocksAvailable;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfsbfree
  @JS('bfree')
  external JSBigInt get blocksFree;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfsblocks
  external JSBigInt get blocks;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfsbsize
  @JS('bsize')
  external JSBigInt get blockSize;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfsffree
  @JS('ffree')
  external JSBigInt get filesFree;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfsfiles
  external JSBigInt get files;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statfstype
  external JSBigInt get type;
}
