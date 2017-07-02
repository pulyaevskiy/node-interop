// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NodeJS interop library.
///
/// Provides interface definitions for NodeJS APIs and allows writing Dart
/// applications and libraries which can be compiled and used in NodeJS.
@JS()
library node_interop;

import 'dart:js' as js;

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;

import 'src/bindings/globals.dart' as globals;

export 'src/bindings/globals.dart' show require, JsPromise, Console, console;
export 'src/platform.dart' show NodePlatform, Platform;
export 'src/util.dart';

/// Keeps reference to the global native `exports` object provided by Node.
/// Use [exports.setProperty] to expose functionality of your module:
///
///     exports.setProperty('simplePi', 3.14);
Exports get exports {
  if (_exports != null) return _exports;
  _exports = new Exports._(globals.exports);
  return _exports;
}

Exports _exports;

class Exports {
  final dynamic _exports;

  Exports._(this._exports);

  void setProperty(String name, dynamic value) {
    if (value is Function) {
      js_util.setProperty(_exports, name, js.allowInterop(value));
    } else {
      js_util.setProperty(_exports, name, value);
    }
  }
}
