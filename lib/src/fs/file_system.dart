// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of node_interop.fs;

class NodeFileSystem implements FileSystem {
  const NodeFileSystem();

  @override
  Directory get currentDirectory => new _Directory(process.cwd());

  @override
  set currentDirectory(path) {
    process.chdir(path);
  }

  @override
  Directory directory(path) => new _Directory(path);

  @override
  File file(path) => new _File(path);

  @override
  String getPath(path) {
    throw new UnimplementedError();
  }

  @override
  Future<bool> identical(String path1, String path2) {
    throw new UnimplementedError();
  }

  @override
  bool identicalSync(String path1, String path2) {
    throw new UnimplementedError();
  }

  @override
  Future<bool> isDirectory(String path) async {
    var stat = await _FileStat.stat(path);
    return stat.type == FileSystemEntityType.DIRECTORY;
  }

  @override
  bool isDirectorySync(String path) {
    var stat = _FileStat.statSync(path);
    return stat.type == FileSystemEntityType.DIRECTORY;
  }

  @override
  Future<bool> isFile(String path) async {
    var stat = await _FileStat.stat(path);
    return stat.type == FileSystemEntityType.FILE;
  }

  @override
  bool isFileSync(String path) {
    var stat = _FileStat.statSync(path);
    return stat.type == FileSystemEntityType.FILE;
  }

  @override
  Future<bool> isLink(String path) async {
    var stat = await _FileStat.stat(path);
    return stat.type == FileSystemEntityType.LINK;
  }

  @override
  bool isLinkSync(String path) {
    var stat = _FileStat.statSync(path);
    return stat.type == FileSystemEntityType.LINK;
  }

  @override
  bool get isWatchSupported {
    throw new UnsupportedError(
        'Testing for watch operations is not supported by Node API');
  }

  @override
  Link link(path) {
    throw new UnimplementedError();
  }

  @override
  Context get path => new Context(current: process.cwd());

  @override
  Future<FileStat> stat(String path) => _FileStat.stat(path);

  @override
  FileStat statSync(String path) => _FileStat.statSync(path);

  @override
  Directory get systemTempDirectory => new _Directory(os.tmpdir());

  @override
  Future<FileSystemEntityType> type(String path, {bool followLinks: true}) {
    throw new UnimplementedError();
  }

  @override
  FileSystemEntityType typeSync(String path, {bool followLinks: true}) {
    throw new UnimplementedError();
  }
}
