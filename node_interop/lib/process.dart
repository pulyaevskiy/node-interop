// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "process" module bindings.
///
/// The `process` object is a global that provides information about, and
/// control over, the current Node.js process.
///
/// As a global, it is always available to Node.js applications without using
/// `require()`.
@JS()
library node_interop.process;

import 'package:js/js.dart';

import 'events.dart';
import 'module.dart';
import 'net.dart';
import 'stream.dart';
import 'tty.dart';

@JS()
@anonymous
abstract class Process implements EventEmitter {
  external void abort();
  external String get arch;
  external List get argv;
  external String get argv0;
  external dynamic get channel;
  external void chdir(String directory);
  external dynamic get config;
  external bool get connected;
  external CPUUsage cpuUsage([CPUUsage previousValue]);
  external String cwd();
  external void disconnect();
  external void dlopen(module, String filename, [int flags]);

  /// See official documentation for possible signatures:
  /// - https://nodejs.org/api/process.html#process_process_emitwarning_warning_options
  /// - https://nodejs.org/api/process.html#process_process_emitwarning_warning_type_code_ctor
  external void emitWarning(warning, [arg1, arg2, arg3]);
  external dynamic get env;
  external List get execArgv;
  external String get execPath;
  external void exit([int code = 0]);
  external int get exitCode;
  external set exitCode(int code);
  external num getegid();
  external dynamic geteuid();
  external dynamic getgid();
  external List getgroups();
  external int getuid();
  external bool hasUncaughtExceptionCaptureCallback();
  external List hrtime([List<int> time]);
  external void initgroups(user, extra_group);
  external void kill(num pid, [signal]);
  external Module get mainModule;
  external dynamic memoryUsage();
  external void nextTick(Function callback,
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
  external bool get noDeprecation;
  external int get pid;
  external String get platform;
  external int get ppid;
  external Release get release;
  external bool send(message, [sendHandle, options, void Function() callback]);
  external void setegid(id);
  external void seteuid(id);
  external void setgid(id);
  external void setgroups(List groups);
  external void setuid(id);
  external void setUncaughtExceptionCaptureCallback(Function fn);

  /// Stream connected to `stderr` (fd `2`).
  ///
  /// It is a [Socket] (which is a [Duplex] stream) unless fd `2` refers to a
  /// file, in which case it is a [Writable] stream.
  external TTYWriteStream get stderr;

  /// Stream connected to `stdin` (fd `0`).
  ///
  /// It is a [Socket] (which is a [Duplex] stream) unless fd `0` refers to a
  /// file, in which case it is a [Readable] stream.
  external TTYReadStream get stdin;

  /// Stream connected to `stdout` (fd `1`).
  ///
  /// It is a [Socket] (which is a [Duplex] stream) unless fd `1` refers to a
  /// file, in which case it is a [Writable] stream.
  external TTYWriteStream get stdout;
  external bool get throwDeprecation;
  external String get title;
  external bool get traceDeprecation;
  external void umask([int mask]);
  external num uptime();
  external String get version;
  external dynamic get versions;
}

@JS()
@anonymous
abstract class CPUUsage {
  external int get user;
  external int get system;
}

@JS()
@anonymous
abstract class Release {
  external String get name;
  external String get sourceUrl;
  external String get headersUrl;
  external String get libUrl;
  external String get lts;
}
