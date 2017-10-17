// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.globals;

import 'package:js/js.dart';

/// Returns a list of keys in [jsObject].
///
/// This function binds to JavaScript `Object.keys()`.
@JS('Object.keys')
external List<String> jsObjectKeys(jsObject);

@JS()
abstract class Thenable<T> {
  external Thenable<S> then<S>(S onFulfilled(T value), [S onRejected(error)]);
}

@JS()
abstract class Promise<T> extends Thenable<T> {
  external factory Promise(executor(resolve(T value), reject(error)));
  external Promise<S> then<S>(S onFulfilled(T value), [S onRejected(error)]);
}

/// Requires (imports) a module specified by [id].
///
/// Example using "dns" module:
///
///     DNS dns = require('dns');
///     var options = new DNSLookupOptions(all: true, verbatim: true);
///     void lookupHandler(error, List<DNSAddress> addresses) {
///       console.log(addresses);
///     }
///     dns.lookup('google.com', options, allowInterop(lookupHandler));
@JS()
external dynamic require(String id);

/// Reference to Node's `module` object;
///
/// See also:
///   - [https://nodejs.org/api/modules.html#modules_the_module_object](https://nodejs.org/api/modules.html#modules_the_module_object)
@JS()
external Module get module;

@JS()
abstract class Module {
  external dynamic get children;
  external dynamic get exports;
  external set exports(value);
}

/// Returns reference to Node's `exports` object.
@JS()
external dynamic get exports;

/// Replaces current module exports with [value].
///
/// Use with care, this effectively detaches `exports` from `module.exports`.
///
/// See also:
///   - [https://nodejs.org/api/modules.html#modules_exports_shortcut](https://nodejs.org/api/modules.html#modules_exports_shortcut)
@JS()
external set exports(dynamic value);

@JS('__dirname')
external String get nodeDirname;

@JS('__filename')
external String get nodeFilename;

@JS()
abstract class Date {
  external String toISOString();
}

@JS()
external Console get console;

@JS('console.Console')
abstract class Console {
  external void log(data, [List args]);
  external void error(data, [List args]);
  external void info(data, [List args]);
  external void warn(data, [List args]);
  external factory Console(stdout, [stderr]);
}

@JS()
abstract class Buffer {
  external static from(Iterable<int> bytes);
}

@JS('Error')
abstract class JsError {
  external String get code;
  external String get message;
  external String get stack;
}

@JS('AssertionError')
abstract class JsAssertionError extends JsError {}

@JS('RangeError')
abstract class JsRangeError extends JsError {}

@JS('ReferenceError')
abstract class JsReferenceError extends JsError {}

@JS('SyntaxError')
abstract class JsSyntaxError extends JsError {}

@JS('TypeError')
abstract class JsTypeError extends JsError {}

@JS('SystemError')
abstract class JsSystemError extends JsError {
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
