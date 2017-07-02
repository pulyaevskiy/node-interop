// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.globals;

import 'package:js/js.dart';

@JS('Object.keys')
external List<String> jsObjectKeys(jsObject);

@JS('Promise')
abstract class JsPromise {
  external factory JsPromise(executor(Function resolve, Function reject));
  external JsPromise then(Function onFulfilled, [Function onRejected]);
}

@JS()
external dynamic require(String id);

@JS()
external dynamic get exports;

// Need these because underscored names are private to this library.
String get dirname => __dirname;
String get filename => __filename;

@JS()
external String get __dirname;

@JS()
external String get __filename;

@JS('Date')
abstract class JsDate {
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
