// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node "path" module bindings.
///
/// Use top-level [path] object to access functionality of this module.
@JS()
library node_interop.path;

import 'package:js/js.dart';

import 'node.dart';

Path get path => require('path');

@JS()
@anonymous
abstract class Path {
  external String basename(String path, [String ext]);
  external String dirname(String path);
  external String extname(String path);
  external bool isAbsolute(String path);
  external String join(String arg1,
      [String arg2, String arg3, String arg4, String arg5]);
  external String normalize(String path);
  external String resolve(
      [String arg1, String arg2, String arg3, String arg4, String arg5]);
  external String get delimiter;
  external String get sep;
  external Path get win32;
  external Path get posix;
}
