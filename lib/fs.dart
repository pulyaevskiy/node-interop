// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// File system implementation powered by Node's IO and "fs" module.
///
/// _This library implements interfaces defined in the "file" package._
///
/// Use [NodeFileSystem] class as the main entry point:
///
///     import 'package:node_interop/fs.dart';
///
///     void main() {
///       const fs = const NodeFileSystem();
///       print(fs.currentDirectory);
///       Directory dir = fs.directory('/some/path');
///       print("Directory ${dir.path} exists: ${dir.existsSync()}");
///     }
library node_interop.fs;

import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;

import 'package:file/file.dart';
import 'package:path/path.dart';

import 'src/bindings/fs.dart';
import 'src/bindings/globals.dart';
import 'src/bindings/os.dart';
import 'src/bindings/process.dart';
import 'src/platform.dart';

export 'package:file/file.dart'
    show
        Directory,
        File,
        FileStat,
        FileSystem,
        FileSystemEntity,
        FileSystemEntityType;

part 'src/fs/directory.dart';
part 'src/fs/file.dart';
part 'src/fs/file_system.dart';
part 'src/fs/file_system_entity.dart';

const Platform _platform = const NodePlatform();
final FS _nodeFS = require('fs');
final OS _nodeOS = require('os');
