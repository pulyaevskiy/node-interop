// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node I/O system for Dart.
///
/// This library is designed so that you should be able to replace imports of
/// `dart:io` with `package:node_io/node_io.dart` and get the same functionality
/// working.
library node_io;

import 'package:node_interop/node.dart';

export 'dart:io'
    show
        FileSystemEntityType,
        FileMode,
        IOSink,
        RandomAccessFile,
        FileSystemException;

export 'src/directory.dart';
export 'src/file.dart';
export 'src/file_system_entity.dart';
export 'src/http_headers.dart' hide HttpHeaders;
export 'src/http_server.dart';
export 'src/internet_address.dart';
export 'src/link.dart';
export 'src/platform.dart';

int get exitCode => process.exitCode;

set exitCode(int value) {
  process.exitCode = value;
}

void exit([int code]) {
  if (code is! int) {
    throw new ArgumentError("Integer value for exit code expected");
  }
  process.exit(code);
}

int get pid => process.pid;
