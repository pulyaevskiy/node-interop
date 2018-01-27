// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node "child_process" module bindings.
///
/// Use top-level [childProcess] object to access this module functionality.
@JS()
library node_interop.child_process;

import 'package:js/js.dart';

import 'node.dart';
import 'events.dart';

ChildProcessModule get childProcess => require('child_process');

@JS()
@anonymous
abstract class ChildProcessModule {
  external ChildProcess exec(String command,
      [ExecOptions options, ExecCallback callback]);
  external ChildProcess execSync(String command, [ExecOptions options]);
}

typedef void ExecCallback(JsError error, stdout, stderr);

@JS()
abstract class ChildProcess extends EventEmitter {}

@JS()
@anonymous
abstract class ExecOptions {
  external String get cwd;
  external dynamic get env;
  external String get encoding;
  external String get shell;
  external num get timeout;
  external num get maxBuffer;
  external num get uid;
  external num get gid;

  external factory ExecOptions({
    String cwd,
    dynamic env,
    String encoding,
    String shell,
    num timeout,
    num maxBuffer,
    num uid,
    num gid,
  });
}
