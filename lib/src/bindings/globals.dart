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

String get dirname => __dirname;
String get filename => __filename;

@JS()
external String get __dirname;

@JS()
external String get __filename;
