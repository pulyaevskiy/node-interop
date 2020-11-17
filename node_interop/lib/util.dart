// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Utility functions for Dart <> JS interoperability.
@JS()
library node_interop.util;

import 'dart:async';
import 'dart:js';

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;

import 'node.dart';

export 'package:js/js_util.dart' hide jsify;

Util get util => _util ??= require('util');
Util _util;

@JS()
@anonymous
abstract class Util {
  /// Possible signatures:
  ///
  /// inspect(object[, options])
  /// inspect(object[, showHidden[, depth[, colors]]])
  external dynamic inspect(object, [arg1, arg2, arg3]);
}

/// Returns Dart representation from JS Object.
///
/// Basic types (`num`, `bool`, `String`) are returned as-is. JS arrays
/// are converted into `List` instances. JS objects are converted into
/// `Map` instances. Both arrays and objects are traversed recursively
/// converting nested values.
///
/// Converting JS objects always results in a `Map<String, dynamic>` meaning
/// even if original object had an integer key set, it will be converted into
/// a `String`. This is different from JS semantics where you are allowed to
/// access a key by passing its int value, e.g. `obj[1]` would work in JS,
/// but fail in Dart.
///
/// See also:
/// - [jsify]
T dartify<T>(Object jsObject) {
  if (_isBasicType(jsObject)) {
    return jsObject as T;
  }

  if (jsObject is List) {
    return jsObject.map(dartify).toList() as T;
  }

  var keys = objectKeys(jsObject);
  var result = <String, dynamic>{};
  for (var key in keys) {
    result[key] = dartify(js_util.getProperty(jsObject, key));
  }

  return result as T;
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

  return js_util.jsify(dartObject);
}

/// Returns `true` if the [value] is a very basic built-in type - e.g.
/// [null], [num], [bool] or [String]. It returns `false` in the other case.
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
///   - [futureToPromise]
Future<T> promiseToFuture<T>(Promise promise) {
  var completer = Completer<T>.sync();
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
/// - [promiseToFuture]
Promise futureToPromise<T>(Future<T> future) {
  return Promise(allowInterop((Function resolve, Function reject) {
    future.then(resolve, onError: reject);
  }));
}

/// Returns a function that can be passed to a Node.js-style asynchronous
/// callback that will complete [completer] with that callback's error or
/// success result.
void Function(Object, T) callbackToCompleter<T>(Completer<T> completer) {
  return allowInterop((error, [value]) {
    if (error != null) {
      completer.completeError(error);
    } else {
      completer.complete(value);
    }
  });
}

/// Invokes a zero-argument Node.js-style asynchronous function and encapsulates
/// the result in a `Future`.
Future<T> invokeAsync0<T>(void Function(void Function(Object, T)) function) {
  var completer = Completer<T>();
  function(callbackToCompleter(completer));
  return completer.future;
}

/// Invokes a single-argument Node.js-style asynchronous function and
/// encapsulates the result in a `Future`.
Future<T> invokeAsync1<S, T>(void Function(S, void Function(Object, T)) function, S arg1) {
  var completer = Completer<T>();
  function(arg1, callbackToCompleter(completer));
  return completer.future;
}
