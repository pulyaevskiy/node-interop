// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.globals;

import 'package:js/js.dart';

/// Returns a list of keys in [jsObject].
/// This function binds to JavaScript `Object.keys()`.
@JS('Object.keys')
external List<String> jsObjectKeys(jsObject);

@JS()
abstract class Promise {
  external factory Promise(executor(Function resolve, Function reject));
  external Promise then(Function onFulfilled, [Function onRejected]);
}

@JS()
external dynamic require(String id);

@JS()
external dynamic get exports;

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
