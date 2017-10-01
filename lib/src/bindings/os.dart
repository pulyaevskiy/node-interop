// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.os;

import 'package:js/js.dart';

@JS()
abstract class OS {
  external List<CPU> cpus();
  external String tmpdir();
  external String hostname();
}

@JS()
abstract class CPU {}
