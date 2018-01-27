// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node OS module bindings.
///
/// Use top-level [os] object to access functionality of this module.
@JS()
library node_interop.os;

import 'package:js/js.dart';

import 'node.dart';

OS get os => require('os');

@JS()
@anonymous
abstract class OS {
  external List<CPU> cpus();
  external String tmpdir();
  external String platform();
  external String hostname();
}

@JS()
@anonymous
abstract class CPU {
  external String get model;
  external num get speed;
}
