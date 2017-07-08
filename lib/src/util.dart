// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.util;

import 'dart:async';
import 'dart:js';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'bindings/globals.dart';

/// Converts JsObject into a Dart `Map`.
Map<String, dynamic> jsObjectToMap(object) {
  var result = new Map<String, dynamic>();
  var keys = jsObjectKeys(object);
  keys.forEach((key) {
    result[key] = getProperty(object, key);
  });
  return result;
}

/// Creates Dart `Future` which completes when [promise] is resolved or
/// rejected.
///
/// See also:
///   - [futureToJsPromise]
Future jsPromiseToFuture(JsPromise promise) {
  var completer = new Completer();
  promise.then(allowInterop((value) {
    completer.complete(value);
  }), allowInterop((error) {
    completer.completeError(error);
  }));
  return completer.future;
}

/// Creates JS `Promise` which is resolved when [future] completes.
///
/// See also:
/// - [jsPromiseToFuture]
dynamic futureToJsPromise(Future future) {
  return new JsPromise(allowInterop((Function resolve, Function reject) {
    future.then(resolve, onError: reject);
  }));
}
