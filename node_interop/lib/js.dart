// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Bindings for global JavaScript objects not specific to Node.js.
@JS()
library node_interop.js;

import 'package:js/js.dart';

@JS()
external dynamic get undefined;

@JS()
abstract class Promise {
  external factory Promise(
      Function(dynamic Function(dynamic value) resolve,
              dynamic Function(dynamic error) reject)
          executor);
  external Promise then(dynamic Function(dynamic value) onFulfilled,
      [dynamic Function(dynamic error) onRejected]);
}

@JS()
abstract class Date {
  external factory Date(dynamic value);
  external int getTime();
  external String toISOString();
}

/// Returns a list of keys in a JavaScript [object].
///
/// This function binds to JavaScript `Object.keys()`.
@JS('Object.keys')
external List<String> objectKeys(object);

/// JavaScript Error object.
@JS('Error')
abstract class JsError {
  external factory JsError([message]);

  external String get message;
  external String get stack;
}

/// A namespace for JavaScript's `Atomics` functions.
@JS()
abstract class Atomics {
  @JS('add')
  external static int add(List<int> typedArray, int index, int value);

  @JS('and')
  external static int and(List<int> typedArray, int index, int value);

  @JS('compareExchange')
  external static int compareExchange(
      List<int> typedArray, int index, int expectedValue, int replacementValue);

  @JS('exchange')
  external static int exchange(List<int> typedArray, int index, int value);

  @JS('isLockFree')
  external static bool isLockFree(int size);

  @JS('load')
  external static int load(List<int> typedArray, int index);

  @JS('notify')
  external static int notify(List<int> typedArray, int index, [int count]);

  @JS('or')
  external static int or(List<int> typedArray, int index, int value);

  @JS('store')
  external static int store(List<int> typedArray, int index, int value);

  @JS('sub')
  external static int sub(List<int> typedArray, int index, int value);

  @JS('wait')
  external static String wait(List<int> typedArray, int index, int value,
      [num timeout]);

  @JS('xor')
  external static int xor(List<int> typedArray, int index, int value);
}
