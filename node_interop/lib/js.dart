// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Bindings for global JavaScript objects not specific to Node.js.
@JS()
library node_interop.js;

import 'package:js/js.dart';

@JS()
external get undefined;

@JS()
abstract class Promise {
  external factory Promise(executor(resolve(value), reject(error)));
  external Promise then(dynamic onFulfilled(value), [onRejected(error)]);
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
