// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.fs;

import 'dart:convert';

import 'dart:async';
import 'dart:js' as js;

import 'package:js/js.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';

import 'src/platform.dart';
import 'src/bindings/fs.dart';
import 'src/bindings/os.dart';
import 'src/bindings/process.dart';

export 'package:file/file.dart'
    show
        Directory,
        File,
        FileStat,
        FileSystem,
        FileSystemEntity,
        FileSystemEntityType;

part 'src/fs/file_system.dart';
part 'src/fs/file_system_entity.dart';
part 'src/fs/file.dart';
part 'src/fs/directory.dart';

const Platform _platform = const NodePlatform();
