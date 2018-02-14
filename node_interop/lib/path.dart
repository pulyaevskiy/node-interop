// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node "path" module bindings.
///
/// Use top-level [path] object to access functionality of this module.
@JS()
library node_interop.path;

import 'package:js/js.dart';

import 'node.dart';

Path get path => _path ??= require('path');
Path _path;

@JS()
@anonymous
abstract class Path {
  external String get delimiter;
  external String get sep;
  external Path get win32;
  external Path get posix;
  external String basename(String path, [String ext]);
  external String dirname(String path);
  external String extname(String path);
  external String format(PathObject path);
  external bool isAbsolute(String path);
  external String join(String arg1,
      [String arg2, String arg3, String arg4, String arg5]);
  external String normalize(String path);
  external PathObject parse(String path);
  external String relative(String from, String to);
  external String resolve(
      [String arg1, String arg2, String arg3, String arg4, String arg5]);
  external String toNamespacedPath(String path);
}

@JS()
@anonymous
abstract class PathObject {
  external factory PathObject(
      {String dir, String root, String base, String name, String ext});
  external String get dir;
  external String get root;
  external String get base;
  external String get name;
  external String get ext;
}
