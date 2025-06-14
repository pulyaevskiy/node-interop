// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

/// The Node.js [`fs.Stats` object], with integer values.
///
/// [`fs.Stats` object]: https://nodejs.org/docs/latest/api/fs.html#class-fsstats
@anonymous
extension type FSStats._(JSObject _) implements JSObject {
  external int get dev;
  external int get ino;
  external int get mode;
  external int get nlink;
  external int get uid;
  external int get gid;
  external int get rdev;
  external int get size;
  external int get blksize;
  external int get blocks;
  external double get atimeMs;
  external double get mtimeMS;
  external double get ctimeMS;
  external double get birthtimeMS;
  external JSDate get atime;
  external JSDate get mtime;
  external JSDate get ctime;
  external JSDate get birthtime;
}
