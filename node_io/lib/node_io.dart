// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js I/O system for Dart.
///
/// This library is designed so that you should be able to replace imports of
/// `dart:io` with `package:node_io/node_io.dart` and get the same functionality
/// working without any additional modifications.
library node_io;

import 'package:file/file.dart' as file;
import 'package:node_interop/node.dart';

import 'src/file_system.dart';
import 'src/stdout.dart';

export 'dart:io'
    show
        BytesBuilder,
        Datagram,
        FileSystemEntity,
        FileSystemEntityType,
        FileMode,
        IOSink,
        RandomAccessFile,
        FileSystemException,
        HttpHeaders,
        OSError;

export 'src/directory.dart';
export 'src/file.dart';
export 'src/file_system_entity.dart' show FileStat;
export 'src/http_server.dart';
export 'src/internet_address.dart';
export 'src/link.dart';
export 'src/network_interface.dart';
export 'src/platform.dart';
export 'src/stdout.dart';

/// Get the global exit code for the current process.
///
/// The exit code is global and the last assignment to exitCode
/// determines the exit code of the process on normal termination.
///
/// See [exit] for more information on how to chose a value for the exit code.
int get exitCode => process.exitCode;

/// Set the global exit code for the current process.
///
/// The exit code is global and the last assignment to exitCode
/// determines the exit code of the process on normal termination.
///
/// Default value is 0.
///
/// See [exit] for more information on how to chose a value for the exit code.
set exitCode(int value) {
  process.exitCode = value;
}

/// Exit the process immediately with the given exit code.
///
/// This does not wait for any asynchronous operations to terminate. Using
/// exit is therefore very likely to lose data.
///
/// The handling of exit codes is platform specific.
///
/// On Linux and OS X an exit code for normal termination will always be in
/// the range 0..255. If an exit code outside this range is set the actual
/// exit code will be the lower 8 bits masked off and treated as an unsigned
/// value. E.g. using an exit code of -1 will result in an actual exit code of
/// 255 being reported.
///
/// On Windows the exit code can be set to any 32-bit value. However some of
/// these values are reserved for reporting system errors like crashes.
void exit([int code]) {
  if (code is! int) {
    throw ArgumentError('Integer value for exit code expected');
  }
  process.exit(code);
}

/// Returns the PID of the current process.
int get pid => process.pid;

/// The standard output stream of errors written by this program.
Stdout get stderr {
  return Stdout(process.stderr);
}

/// The standard output stream of data written by this program.
Stdout get stdout {
  return Stdout(process.stdout);
}

/// A `file` package filesystem backed by Node.js's `fs` API.
const file.FileSystem nodeFileSystem = NodeFileSystem();
