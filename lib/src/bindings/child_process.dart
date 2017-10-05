@JS()
library node_interop.bindings.child_process;

import 'package:js/js.dart';

import 'events.dart';

/// Main entry point to Node's "child_process" module.
///
/// Usage:
///
///     ChildProcessModule child = require("child_process");
///     child.execSync("npm install");
@JS()
abstract class ChildProcessModule {
  external ChildProcess execSync(String command, [ExecOptions options]);
}

@JS()
abstract class ChildProcess implements EventEmitter {}

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
