// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'package:node_interop/fs.dart';
import 'package:node_interop/path.dart' as nodePath;
import 'package:js/js.dart' as js;

import 'directory.dart';
import 'platform.dart';

abstract class FileSystemEntity implements io.FileSystemEntity {
  static final RegExp _absoluteWindowsPathPattern =
      new RegExp(r'^(\\\\|[a-zA-Z]:[/\\])');

  @override
  bool get isAbsolute => nodePath.path.isAbsolute(path);

  @override
  String toString() => "$runtimeType: '$path'";

  static final RegExp _parentRegExp = Platform.isWindows
      ? new RegExp(r'[^/\\][/\\]+[^/\\]')
      : new RegExp(r'[^/]/+[^/]');

  static String parentOf(String path) {
    int rootEnd = -1;
    if (Platform.isWindows) {
      if (path.startsWith(_absoluteWindowsPathPattern)) {
        // Root ends at first / or \ after the first two characters.
        rootEnd = path.indexOf(new RegExp(r'[/\\]'), 2);
        if (rootEnd == -1) return path;
      } else if (path.startsWith('\\') || path.startsWith('/')) {
        rootEnd = 0;
      }
    } else if (path.startsWith('/')) {
      rootEnd = 0;
    }
    // Ignore trailing slashes.
    // All non-trivial cases have separators between two non-separators.
    int pos = path.lastIndexOf(_parentRegExp);
    if (pos > rootEnd) {
      return path.substring(0, pos + 1);
    } else if (rootEnd > -1) {
      return path.substring(0, rootEnd + 1);
    } else {
      return '.';
    }
  }

  @override
  io.Directory get parent => new Directory(parentOf(path));

  @override
  Future<String> resolveSymbolicLinks() {
    var completer = new Completer<String>();
    void callback(err, String resolvedPath) {
      if (err == null) {
        completer.complete(resolvedPath);
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);

    fs.realpath(path, jsCallback);
    return completer.future;
  }

  @override
  String resolveSymbolicLinksSync() => fs.realpathSync(path);

  @override
  Future<FileStat> stat() => FileStat.stat(path);

  @override
  FileStat statSync() => FileStat.statSync(path);

  @override
  Uri get uri => new Uri.file(path, windows: Platform.isWindows);

  @override
  Stream<io.FileSystemEvent> watch(
      {int events: io.FileSystemEvent.ALL, bool recursive: false}) {
    throw new UnimplementedError();
  }
}

class FileStat implements io.FileStat {
  @override
  final DateTime changed;

  @override
  final DateTime modified;

  @override
  final DateTime accessed;

  @override
  final io.FileSystemEntityType type;

  @override
  final int mode;

  @override
  final int size;

  FileStat._internal(this.changed, this.modified, this.accessed, this.type,
      this.mode, this.size);

  const FileStat._internalNotFound()
      : changed = null,
        modified = null,
        accessed = null,
        type = io.FileSystemEntityType.NOT_FOUND,
        mode = 0,
        size = -1;

  factory FileStat._fromNodeStats(Stats stats) {
    var type = io.FileSystemEntityType.NOT_FOUND;
    if (stats.isDirectory()) {
      type = io.FileSystemEntityType.DIRECTORY;
    } else if (stats.isFile()) {
      type = io.FileSystemEntityType.FILE;
    } else if (stats.isSymbolicLink()) {
      type = io.FileSystemEntityType.LINK;
    }
    return new FileStat._internal(
      DateTime.parse(stats.ctime.toISOString()),
      DateTime.parse(stats.mtime.toISOString()),
      DateTime.parse(stats.atime.toISOString()),
      type,
      stats.mode,
      stats.size,
    );
  }

  static Future<io.FileStat> stat(String path) {
    var completer = new Completer<io.FileStat>();
    void callback(err, stats) {
      if (err == null) {
        completer.complete(new FileStat._fromNodeStats(stats));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);
    fs.stat(path, jsCallback);
    return completer.future;
  }

  static io.FileStat statSync(String path) =>
      new FileStat._fromNodeStats(fs.statSync(path));

  @override
  String modeString() {
    var permissions = mode & 0xFFF;
    var codes = const ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'];
    var result = [];
    if ((permissions & 0x800) != 0) result.add("(suid) ");
    if ((permissions & 0x400) != 0) result.add("(guid) ");
    if ((permissions & 0x200) != 0) result.add("(sticky) ");
    result
      ..add(codes[(permissions >> 6) & 0x7])
      ..add(codes[(permissions >> 3) & 0x7])
      ..add(codes[permissions & 0x7]);
    return result.join();
  }

  @override
  String toString() => """
FileStat: type $type
          changed $changed
          modified $modified
          accessed $accessed
          mode ${modeString()}
          size $size""";
}
