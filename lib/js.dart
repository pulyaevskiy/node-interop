// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Bindings for global JavaScript objects not specific to Node itself.
@JS()
library node_interop.js;

import 'package:js/js.dart';

@JS()
abstract class Thenable<T> {
  external Thenable<S> then<S>(S onFulfilled(T value), [S onRejected(error)]);
}

@JS()
abstract class Promise<T> extends Thenable<T> {
  external factory Promise(executor(resolve(T value), reject(error)));
  external Promise<S> then<S>(S onFulfilled(T value), [S onRejected(error)]);
}

@JS()
abstract class Date {
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
  external JsError([String message, String fileName, int lineNumber]);

  external String get message;
  external String get stack;
}
