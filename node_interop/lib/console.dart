// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library node_interop.console;

import 'package:js/js.dart';

@JS()
abstract class Console {
  external void log(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
}
