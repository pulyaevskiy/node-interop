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

/// Converts a JavaScript value to a JSON string. This functions binds to
/// native `JSON.stringify()`.
///
/// Optionally replaces values if a [replacer] function is specified, or
/// optionally including only the specified properties if a [replacer] array is
/// specified.
///
/// The [space] parameter can be a `String` or `num` object that's used to
/// insert white space into the output JSON string for readability purposes.
@JS("JSON.stringify")
external String jsonStringify(object, [replacer, space]);

/// Parses a JSON [text], constructing the JavaScript value or object described
/// by the string. This functions binds to native `JSON.parse()`.
///
/// An optional [reviver] function can be provided to perform a transformation
/// on the resulting object before it is returned.
@JS("JSON.parse")
external dynamic jsonParse(String text, [reviver]);
