// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.process;

import 'package:js/js.dart';

@JS()
abstract class Process {
  external String get platform;
  external String cwd();
  external void chdir(String directory);
  external List<String> get execArgv;
  external String get execPath;
  external String get argv0;
  external dynamic get env;
}

@JS()
external Process get process;
