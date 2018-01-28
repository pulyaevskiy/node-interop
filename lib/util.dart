// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.util;

import 'dart:async';
import 'dart:js';

import 'package:js/js.dart';
import 'package:js/js_util.dart' as util;

import 'node.dart';

/// Returns Dart representation from JS Object.
///
/// Basic types (num, bool, String) are returned as-is. JS arrays
/// are converted into `List` instances. JS objects are converted into
/// `Map` instances. Both arrays and objects are traversed recursively
/// converting nested values.
///
/// See also:
/// - [jsify]
dynamic dartify(Object jsObject) {
  assert(jsObject is! Function, "Can not dartify a function.");

  if (_isBasicType(jsObject)) {
    return jsObject;
  }

  if (jsObject is List) {
    return jsObject.map(dartify).toList();
  }

  var keys = objectKeys(jsObject);
  var result = new Map();
  for (var key in keys) {
    result[key] = dartify(util.getProperty(jsObject, key));
  }

  return result;
}

/// Returns the JS representation from Dart Object.
///
/// This function is identical to the one from 'dart:js_util' with only
/// difference that it handles basic types ([String], [num], [bool] and [null].
///
/// See also:
/// - [dartify]
dynamic jsify(Object dartObject) {
  if (_isBasicType(dartObject)) {
    return dartObject;
  }

  return util.jsify(dartObject);
}

/// Returns [:true:] if the [value] is a very basic built-in type - e.g.
/// [null], [num], [bool] or [String]. It returns [:false:] in the other case.
bool _isBasicType(value) {
  if (value == null || value is num || value is bool || value is String) {
    return true;
  }
  return false;
}

/// Creates Dart `Future` which completes when [promise] is resolved or
/// rejected.
///
/// See also:
///   - [futureToJsPromise]
Future<T> jsPromiseToFuture<T>(Promise<T> promise) {
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
Promise<T> futureToJsPromise<T>(Future<T> future) {
  return new Promise(allowInterop((Function resolve, Function reject) {
    future.then(resolve, onError: reject);
  }));
}
