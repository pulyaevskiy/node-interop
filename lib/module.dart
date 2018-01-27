// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library node_interop.module;

import 'package:js/js.dart';

@JS()
abstract class Module {
  external String get filename;
}
