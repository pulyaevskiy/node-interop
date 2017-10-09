// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NodeJS interop library.
///
/// Provides interface definitions for NodeJS APIs and allows writing Dart
/// applications and libraries which can be compiled and used in NodeJS.
///
/// Some APIs, like 'fs' and 'http' Node modules must be `require`d to use, e.g.:
///
///     FS nodeFS = require('fs');
///     HTTP nodeHTTP = require('http');
///
/// This library also exposes [node] object which provides centralized access to
/// Node's runtime and platform information, as well as some convenience methods
/// for `require` and `exports`.
///
/// See also:
/// - [HTTP]
/// - [FS]
/// - [ChildProcessModule]
@JS()
library node_interop;

import 'dart:js_util' as js_util;

import 'package:js/js.dart';

import 'src/bindings/globals.dart' as globals;
import 'src/platform.dart';

export 'src/bindings/child_process.dart';
export 'src/bindings/dns.dart';
export 'src/bindings/events.dart';
export 'src/bindings/fs.dart';
export 'src/bindings/globals.dart' hide nodeDirname, nodeFilename;
export 'src/bindings/http.dart';
export 'src/bindings/https.dart';
export 'src/bindings/net.dart';
export 'src/bindings/os.dart';
export 'src/bindings/process.dart';
export 'src/util.dart';

/// Node environment helper. Provides access to runtime platform information
/// as well as convenience wrappers for `require` and `exports`.
const node = const Node._();

class Node {
  const Node._();

  /// Platform specific information about this Node process.
  Platform get platform => const NodePlatform();

  /// Loads a module specified by its [id].
  ///
  /// This is a proxy to Node's built-in `require` function.
  dynamic require(String id) => globals.require(id);

  /// Exports [value] with specified property [name].
  ///
  /// This is a proxy to Node's built-in `exports` object.
  ///
  /// If `value` is a Function it's automatically wrapped with `allowInterop`,
  /// otherwise it's passed unchanged so users should make sure to export
  /// functionality which can be directly accessed/executed by JavaScript.
  void export(String name, dynamic value) {
    if (value is Function) {
      js_util.setProperty(globals.exports, name, allowInterop(value));
    } else {
      js_util.setProperty(globals.exports, name, value);
    }
  }

  /// The directory name of the current module.
  String get dirname => globals.nodeDirname;

  /// The file name of the current module. This is the resolved absolute path of
  /// the current module file.
  String get filename => globals.nodeFilename;
}
