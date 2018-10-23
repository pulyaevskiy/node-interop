// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js globals bindings.
@JS()
library node_interop.node;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'console.dart';
import 'js.dart';
import 'module.dart';
import 'process.dart';

export 'buffer.dart';
export 'js.dart';
export 'process.dart';
export 'timers.dart';

/// Loads module with specified [id].
///
/// Note that this is not actually a global variable and when compiled to
/// JavaScript proxies all calls to the `require` function of main application
/// module.
external dynamic require(String id);

/// Reference to the main module's `exports` object.
///
/// Note that this is not actually a global variable and currently only
/// works for the application's main module, meaning it should only be used
/// from inside the `main` function of a Dart application.
///
/// Consider using [setExport] to register exports inside your `main` function.
external dynamic get exports;

/// Registers property with [key] and [value] in the module [exports] object.
void setExport(String key, Object value) {
  setProperty(exports, key, value);
}

external Console get console;

/// Reference to the main module's [Module] object.
///
/// Note that this is not actually a global variable and currently only
/// works for the application's main module, meaning it should only be used
/// from inside the `main` function of a Dart application.
external Module get module;
external Process get process;

@JS()
@anonymous
abstract class NodeJsError implements JsError {
  external String get code;
}

@JS('AssertionError')
abstract class JsAssertionError extends NodeJsError {}

@JS('RangeError')
abstract class JsRangeError extends NodeJsError {}

@JS('ReferenceError')
abstract class JsReferenceError extends NodeJsError {}

@JS('SyntaxError')
abstract class JsSyntaxError extends NodeJsError {}

@JS('TypeError')
abstract class JsTypeError extends NodeJsError {}

@JS('SystemError')
abstract class JsSystemError extends NodeJsError {
  static const String EACCES = 'EACCES';
  static const String EADDRINUSE = 'EADDRINUSE';
  static const String ECONNREFUSED = 'ECONNREFUSED';
  static const String ECONNRESET = 'ECONNRESET';
  static const String EEXIST = 'EEXIST';
  static const String EISDIR = 'EISDIR';
  static const String EMFILE = 'EMFILE';
  static const String ENOENT = 'ENOENT';
  static const String ENOTDIR = 'ENOTDIR';
  static const String ENOTEMPTY = 'ENOTEMPTY';
  static const String EPERM = 'EPERM';
  static const String EPIPE = 'EPIPE';
  static const String ETIMEDOUT = 'ETIMEDOUT';

  external dynamic get errno;
  external String get syscall;
  external String get path;
  external String get address;
  external num get port;
}
