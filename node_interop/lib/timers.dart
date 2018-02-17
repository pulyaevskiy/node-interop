// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "timers" module bindings.
@JS()
library node_interop.timers;

import 'package:js/js.dart';

@JS()
abstract class Immediate {}

@JS()
abstract class Timeout {
  external Timeout ref();
  external Timeout unref();
}

@JS()
external Immediate setImmediate(Function callback,
    [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]);

@JS()
external Timeout setInterval(Function callback, num delay,
    [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]);

@JS()
external Timeout setTimeout(Function callback, num delay,
    [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]);

@JS()
external void clearImmediate(Immediate immediate);

@JS()
external void clearInterval(Timeout timeout);

@JS()
external void clearTimeout(Timeout timeout);
