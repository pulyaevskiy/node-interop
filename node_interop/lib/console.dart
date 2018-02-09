// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library node_interop.console;

import 'package:js/js.dart';

import 'stream.dart';

@JS()
abstract class Console {
  /// Creates a new Console with one or two writable stream instances.
  external factory Console(Writable stdout, [Writable stderr]);

  external void clear();
  external void count([String label]);
  external void countReset([String label]);

  // "assert" is a reserved word in Dart
  // external void assert(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void debug(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void error(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void info(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void log(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void trace(String message,
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void warn(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
}
