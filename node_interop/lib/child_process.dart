// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "child_process" module bindings.
///
/// Use top-level [childProcess] object to access this module functionality.
@JS()
library node_interop.child_process;

import 'package:js/js.dart';

import 'events.dart';
import 'node.dart';
import 'stream.dart';

ChildProcessModule get childProcess =>
    _childProcess ??= require('child_process');
ChildProcessModule _childProcess;

@JS()
@anonymous
abstract class ChildProcessModule {
  /// Spawns a shell then executes the command within that shell, buffering any
  /// generated output.
  external ChildProcess exec(String command,
      [ExecOptions options, ExecCallback callback]);

  /// Similar to [exec] except that it does not spawn a shell.
  ///
  /// The specified executable file is spawned directly as a new process making
  /// it slightly more efficient.
  external ChildProcess execFile(String file,
      [List<String> args, ExecOptions options, ExecCallback callback]);

  /// This is a special case of [spawn] used specifically to spawn new
  /// Node.js processes.
  external ChildProcess fork(String modulePath,
      [List<String> args, ForkOptions options]);

  /// Spawns a new process using the given [command], with command line arguments
  /// in [args].
  external ChildProcess spawn(String command,
      [List<String> args, SpawnOptions options]);

  /// This method is generally identical to [exec] with the exception that it
  /// will not return until the child process has fully closed.
  ///
  /// Returns stdout from the command as a [Buffer] or string.
  external dynamic execSync(String command, [ExecOptions options]);

  /// This method is generally identical to [execFile] with the exception that it
  /// will not return until the child process has fully closed.
  ///
  /// Returns stdout from the command as a [Buffer] or string.
  external dynamic execFileSync(String file,
      [List<String> args, ExecOptions options]);

  /// This method is generally identical to [spawn] with the exception that it
  /// will not return until the child process has fully closed.
  external dynamic spawnSync(String command,
      [List<String> args, ExecOptions options]);
}

typedef ExecCallback = void Function(
    NodeJsError error, dynamic stdout, dynamic stderr);

@JS()
abstract class ChildProcess extends EventEmitter {
  /// Reference to the child's IPC channel. If no IPC channel currently exists,
  /// this property is `undefined`.
  external dynamic get channel;

  /// Indicates whether it is still possible to send and receive messages from
  /// a child process.
  external bool get connected;

  /// Closes the IPC channel between parent and child, allowing the child to exit
  /// gracefully once there are no other connections keeping it alive.
  external void disconnect();

  /// Sends a signal to the child process.
  external void kill([String signal]);

  /// Indicates whether the child process successfully received a signal
  /// from [kill].
  external bool get killed;

  /// The process identifier (PID) of the child process.
  external int get pid;

  /// Send [message] to the child process.
  external bool send(dynamic message,
      [dynamic sendHandle, dynamic options, Function callback]);

  /// A [Readable] stream that represents the child process's stderr.
  external Readable get stderr;

  /// A [Writable] stream that represents the child process's stdin.
  external Writable get stdin;

  /// A sparse array of pipes to the child process.
  external List get stdio;

  /// A [Readable] stream that represents the child process's stdout.
  external Readable get stdout;
}

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

@JS()
@anonymous
abstract class ForkOptions {
  external String get cwd;
  external dynamic get env;
  external String get execPath;
  external List<String> get execArgv;
  external bool get silent;
  external dynamic get stdio;
  external bool get windowsVerbatimArguments;
  external num get uid;
  external num get gid;

  external factory ForkOptions({
    String cwd,
    dynamic env,
    String execPath,
    List<String> execArgv,
    bool silent,
    dynamic stdio,
    bool windowsVerbatimArguments,
    num uid,
    num gid,
  });
}

@JS()
@anonymous
abstract class SpawnOptions {
  external String get cwd;
  external dynamic get env;
  external String get argv0;
  external dynamic get stdio;
  external bool get detached;
  external num get uid;
  external num get gid;
  external dynamic get shell;
  external bool get windowsVerbatimArguments;
  external bool get windowsHide;

  external factory SpawnOptions({
    String cwd,
    dynamic env,
    String argv0,
    dynamic stdio,
    bool detached,
    num uid,
    num gid,
    dynamic shell,
    bool windowsVerbatimArguments,
    bool windowsHide,
  });
}
