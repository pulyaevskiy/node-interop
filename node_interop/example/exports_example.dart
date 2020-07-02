// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:node_interop/node.dart';
import 'package:node_interop/util.dart';

/// A library which slowly calculates value of π.
///
/// After compiled to JavaScript, this library can be used in Node as a regular
/// Node module:
///
///     // file:some/index.js
///     let slow_pi = require('./path/to/build/example/slow_pi.dart.js');
///     console.log(slow_pi.slowPi(1000));
///     console.log(slow_pi.fastPi);
///     console.log(slow_pi.config.defaultAccuracy);
///     // Et cetera.
void main() {
  // Note that functions must be wrapped with `allowInterop`.
  setExport('slowPi', allowInterop(slowPi));

  // As well as complex Dart objects (like Maps) must be jsified.
  setExport('config', jsify({'defaultAccuracy': 100}));

  // Primitive types can be passed as-is.
  setExport('fastPi', 3.1514934010709914);
}

/// Calculates value of π according to specified [accuracy].
double slowPi(int accuracy) {
  var pi = 4.0;
  var top = 4.0;
  var bottom = 3.0;
  var add = false;
  for (var i = 0; i < accuracy; i++) {
    var value = top / bottom;
    pi = add ? pi + value : pi - value;
    add = !add;
    bottom += 2;
  }
  return pi;
}
