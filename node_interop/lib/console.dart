// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "console" module bindings.
@JS()
library node_interop.console;

import 'dart:js_util';

import 'package:js/js.dart';

import 'stream.dart';
import 'node.dart';

ConsoleModule get console => _console ??= require('console');
ConsoleModule _console;

Console createConsole(Writable stdout, [Writable stderr]) {
  if (stderr == null) {
    return callConstructor(console.Console, [stdout]);
  } else {
    return callConstructor(console.Console, [stdout, stderr]);
  }
}

@JS()
@anonymous
abstract class ConsoleModule {
  dynamic get Console;
}

@JS()
@anonymous
abstract class Console {
  external void clear();
  external void count([String label]);
  external void countReset([String label]);

  // Unsupported: "assert" is a reserved word in Dart.
  // external void assert(String data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void debug(data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void dir(object, [options]);
  external void dirxml([arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void error(data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void group([label1, label2, label3, label4, label5, label6]);
  external void groupCollapsed();
  external void groupEnd();
  external void info(data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void log(data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void time(String label);
  external void timeEnd(String label);
  external void trace(message, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external void warn(data, [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  // Inspector only methods:
  external void markTimeline(String label);
  external void profile([String label]);
  external void profileEnd();
  external void table(array, [columns]);
  external void timeStamp([String label]);
  external void timeline([String label]);
  external void timelineEnd([String label]);
}
