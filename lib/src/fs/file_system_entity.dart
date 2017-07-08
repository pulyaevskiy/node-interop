// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of node_interop.fs;

abstract class _FileSystemEntity implements FileSystemEntity {
  static final RegExp _absoluteWindowsPathPattern =
      new RegExp(r'^(\\\\|[a-zA-Z]:[/\\])');

  @override
  String get basename => fileSystem.path.basename(path);

  @override
  String get dirname => fileSystem.path.dirname(path);

  @override
  FileSystem get fileSystem => const NodeFileSystem();

  @override
  bool get isAbsolute => fileSystem.path.isAbsolute(path);

  String get _absolutePath {
    if (isAbsolute) return path;
    return fileSystem.path.absolute(path);
  }

  static final RegExp _parentRegExp = _platform.isWindows
      ? new RegExp(r'[^/\\][/\\]+[^/\\]')
      : new RegExp(r'[^/]/+[^/]');

  static String parentOf(String path) {
    int rootEnd = -1;
    if (_platform.isWindows) {
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
  Directory get parent => new _Directory(parentOf(path));

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

    nodeFS.realpath(path, jsCallback);
    return completer.future;
  }

  @override
  String resolveSymbolicLinksSync() {
    return nodeFS.realpathSync(path);
  }

  @override
  Future<FileStat> stat() => _FileStat.stat(path);

  @override
  FileStat statSync() => _FileStat.statSync(path);

  @override
  Uri get uri => new Uri.file(path, windows: _platform.isWindows);

  @override
  Stream<FileSystemEvent> watch(
      {int events: FileSystemEvent.ALL, bool recursive: false}) {
    throw new UnimplementedError();
  }
}

class _FileStat implements FileStat {
  @override
  final DateTime changed;

  @override
  final DateTime modified;

  @override
  final DateTime accessed;

  @override
  final FileSystemEntityType type;

  @override
  final int mode;

  @override
  final int size;

  _FileStat(this.changed, this.modified, this.accessed, this.type, this.mode,
      this.size);

  factory _FileStat.fromNodeStats(Stats stats) {
    var type = FileSystemEntityType.NOT_FOUND;
    if (stats.isDirectory()) {
      type = FileSystemEntityType.DIRECTORY;
    } else if (stats.isFile()) {
      type = FileSystemEntityType.FILE;
    } else if (stats.isSymbolicLink()) {
      type = FileSystemEntityType.LINK;
    }
    return new _FileStat(
      DateTime.parse(stats.ctime.toISOString()),
      DateTime.parse(stats.mtime.toISOString()),
      DateTime.parse(stats.atime.toISOString()),
      type,
      stats.mode,
      stats.size,
    );
  }

  static Future<FileStat> stat(String path) {
    var completer = new Completer<FileStat>();
    void callback(err, stats) {
      if (err == null) {
        completer.complete(new _FileStat.fromNodeStats(stats));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);
    nodeFS.stat(path, jsCallback);
    return completer.future;
  }

  static FileStat statSync(String path) =>
      new _FileStat.fromNodeStats(nodeFS.statSync(path));

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
