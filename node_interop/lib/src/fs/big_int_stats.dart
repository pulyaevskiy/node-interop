// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

/// The Node.js [`fs.Stats` object], with [JSBigInt] values.
///
/// [`fs.Stats` object]: https://nodejs.org/docs/latest/api/fs.html#class-fsstats
@anonymous
extension type FSBigIntStats._(JSObject _) implements JSObject {
  external JSBigInt get dev;
  external JSBigInt get ino;
  external JSBigInt get mode;
  external JSBigInt get nlink;
  external JSBigInt get uid;
  external JSBigInt get gid;
  external JSBigInt get rdev;
  external JSBigInt get size;
  external JSBigInt get blksize;
  external JSBigInt get blocks;
  external double get atimeMs;
  external double get mtimeMS;
  external double get ctimeMS;
  external double get birthtimeMS;
  external JSDate get atime;
  external JSDate get mtime;
  external JSDate get ctime;
  external JSDate get birthtime;
}
