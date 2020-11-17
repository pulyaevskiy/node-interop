// Copyright (c) 2020, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'package:file/file.dart' as f;
import 'package:node_interop/fs.dart';
import 'package:node_interop/util.dart';
import 'package:path/path.dart' as p;

import 'directory.dart';
import 'file.dart';
import 'file_system_entity.dart';
import 'link.dart';

/// A [FileSystem] implementation backed by Node.js's `fs` module.
class NodeFileSystem extends f.FileSystem {
  const NodeFileSystem();

  @override
  f.Directory directory(dynamic path) => Directory(getPath(path));

  @override
  f.File file(dynamic path) => File(getPath(path));

  @override
  f.Link link(dynamic path) => Link(getPath(path));

  @override
  p.Context get path => p.context;

  @override
  f.Directory get systemTempDirectory => Directory.systemTemp;

  @override
  f.Directory get currentDirectory => Directory.current;

  @override
  set currentDirectory(dynamic path) {
    Directory.current = getPath(path);
  }

  @override
  Future<f.FileStat> stat(String path) => FileStat.stat(path);

  @override
  f.FileStat statSync(String path) => FileStat.statSync(path);

  @override
  Future<bool> identical(String path1, String path2) async {
    var stats = await Future.wait(
        [invokeAsync1(fs.lstat, path1), invokeAsync1(fs.lstat, path2)],
        eagerError: true);

    return stats[0].ino == stats[1].ino && stats[0].dev == stats[1].dev;
  }

  @override
  bool identicalSync(String path1, String path2) {
    var stat1 = fs.lstatSync(path1);
    var stat2 = fs.lstatSync(path2);
    return stat1.ino == stat2.ino && stat1.dev == stat2.dev;
  }

  @override
  final isWatchSupported = false;

  @override
  Future<io.FileSystemEntityType> type(String path,
      {bool followLinks = true}) async {
    Stats stats;
    try {
      stats = await invokeAsync1(followLinks ? fs.stat : fs.lstat, path);
    } catch (_) {
      return io.FileSystemEntityType.notFound;
    }

    if (stats.isDirectory()) return io.FileSystemEntityType.directory;
    if (stats.isFile()) return io.FileSystemEntityType.file;
    if (stats.isSymbolicLink()) return io.FileSystemEntityType.link;
    return io.FileSystemEntityType.notFound;
  }

  @override
  io.FileSystemEntityType typeSync(String path, {bool followLinks = true}) {
    Stats stats;
    try {
      stats = followLinks ? fs.statSync(path) : fs.lstatSync(path);
    } catch (_) {
      return io.FileSystemEntityType.notFound;
    }

    if (stats.isDirectory()) return io.FileSystemEntityType.directory;
    if (stats.isFile()) return io.FileSystemEntityType.file;
    if (stats.isSymbolicLink()) return io.FileSystemEntityType.link;
    return io.FileSystemEntityType.notFound;
  }
}
