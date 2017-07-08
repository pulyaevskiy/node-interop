// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of node_interop.fs;

class _File extends _FileSystemEntity implements File {
  @override
  final String path;

  _File(this.path);

  @override
  File get absolute => new _File(_absolutePath);

  @override
  Future<File> copy(String newPath) {
    // TODO: implement copy
    return null;
  }

  @override
  File copySync(String newPath) {
    // TODO: implement copySync
    return null;
  }

  @override
  Future<File> create({bool recursive: false}) {
    // TODO: implement create
    return null;
  }

  @override
  void createSync({bool recursive: false}) {
    // TODO: implement createSync
    return null;
  }

  @override
  Future<FileSystemEntity> delete({bool recursive: false}) {
    // TODO: implement delete
    return null;
  }

  @override
  void deleteSync({bool recursive: false}) {
    // TODO: implement deleteSync
    return null;
  }

  @override
  Future<bool> exists() async {
    var stat = await _FileStat.stat(path);
    return stat.type == FileSystemEntityType.FILE;
  }

  @override
  bool existsSync() {
    var stat = _FileStat.statSync(path);
    return stat.type == FileSystemEntityType.DIRECTORY;
  }

  @override
  Future<DateTime> lastAccessed() =>
      _FileStat.stat(path).then((_) => _.accessed);

  @override
  DateTime lastAccessedSync() => _FileStat.statSync(path).accessed;

  @override
  Future<DateTime> lastModified() =>
      _FileStat.stat(path).then((_) => _.modified);

  @override
  DateTime lastModifiedSync() => _FileStat.statSync(path).modified;

  @override
  Future<int> length() => _FileStat.stat(path).then((_) => _.size);

  @override
  int lengthSync() => _FileStat.statSync(path).size;

  @override
  Future<RandomAccessFile> open({FileMode mode: FileMode.READ}) =>
      _RandomAccessFile.open(path, mode);

  @override
  Stream<List<int>> openRead([int start, int end]) {
    // TODO: implement openRead
  }

  @override
  RandomAccessFile openSync({FileMode mode: FileMode.READ}) =>
      _RandomAccessFile.openSync(path, mode);

  @override
  IOSink openWrite({FileMode mode: FileMode.WRITE, Encoding encoding: UTF8}) {
    // TODO: implement openWrite
  }

  @override
  Future<List<int>> readAsBytes() {
    // TODO: implement readAsBytes
  }

  @override
  List<int> readAsBytesSync() {
    // TODO: implement readAsBytesSync
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding: UTF8}) {
    // TODO: implement readAsLines
  }

  @override
  List<String> readAsLinesSync({Encoding encoding: UTF8}) {
    // TODO: implement readAsLinesSync
  }

  @override
  Future<String> readAsString({Encoding encoding: UTF8}) {
    // TODO: implement readAsString
  }

  @override
  String readAsStringSync({Encoding encoding: UTF8}) {
    // TODO: implement readAsStringSync
  }

  @override
  Future<File> rename(String newPath) {
    // TODO: implement rename
  }

  @override
  File renameSync(String newPath) {
    // TODO: implement renameSync
  }

  @override
  Future setLastAccessed(DateTime time) {
    // TODO: implement setLastAccessed
  }

  @override
  void setLastAccessedSync(DateTime time) {
    // TODO: implement setLastAccessedSync
  }

  @override
  Future setLastModified(DateTime time) {
    // TODO: implement setLastModified
  }

  @override
  void setLastModifiedSync(DateTime time) {
    // TODO: implement setLastModifiedSync
  }

  @override
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode: FileMode.WRITE, bool flush: false}) {
    // TODO: implement writeAsBytes
  }

  @override
  void writeAsBytesSync(List<int> bytes,
      {FileMode mode: FileMode.WRITE, bool flush: false}) {
    // TODO: implement writeAsBytesSync
  }

  @override
  Future<File> writeAsString(String contents,
      {FileMode mode: FileMode.WRITE,
      Encoding encoding: UTF8,
      bool flush: false}) {
    // TODO: implement writeAsString
  }

  @override
  void writeAsStringSync(String contents,
      {FileMode mode: FileMode.WRITE,
      Encoding encoding: UTF8,
      bool flush: false}) {
    nodeFS.writeFileSync(_absolutePath, contents);
  }
}

class _RandomAccessFile implements RandomAccessFile {
  /// File Descriptor
  final int fd;

  /// File path.
  final String path;

  _RandomAccessFile(this.fd, this.path);

  static Future<_RandomAccessFile> open(String path, FileMode mode) {
    var completer = new Completer<_RandomAccessFile>();
    void cb(err, fd) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(new _RandomAccessFile(fd, path));
      }
    }

    var jsCallback = js.allowInterop(cb);
    nodeFS.open(path, fileModeToJsFlags(mode), jsCallback);
    return completer.future;
  }

  static _RandomAccessFile openSync(String path, FileMode mode) {
    var fd = nodeFS.openSync(path, fileModeToJsFlags(mode));
    return new _RandomAccessFile(fd, path);
  }

  static String fileModeToJsFlags(FileMode mode) {
    switch (mode) {
      case FileMode.READ:
        return 'r';
      case FileMode.WRITE:
        return 'w+';
      case FileMode.WRITE_ONLY:
        return 'w';
      case FileMode.APPEND:
        return 'a+';
      case FileMode.WRITE_ONLY_APPEND:
        return 'a';
      default:
        throw new UnsupportedError('$mode is not supported');
    }
  }

  @override
  Future<RandomAccessFile> close() {
    var completer = new Completer();
    void callback(err) {
      if (err == null) {
        completer.complete(this);
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);
    nodeFS.close(fd, jsCallback);
    return completer.future;
  }

  @override
  void closeSync() {
    nodeFS.closeSync(fd);
  }

  @override
  Future<RandomAccessFile> flush() => new Future.value(this);

  @override
  void flushSync() {
    // no-op
  }

  @override
  Future<int> length() {
    // TODO: implement length
  }

  @override
  int lengthSync() {
    // TODO: implement lengthSync
  }

  @override
  Future<RandomAccessFile> lock(
      [FileLock mode = FileLock.EXCLUSIVE, int start = 0, int end = -1]) {
    // TODO: implement lock
  }

  @override
  void lockSync(
      [FileLock mode = FileLock.EXCLUSIVE, int start = 0, int end = -1]) {
    // TODO: implement lockSync
  }

  @override
  Future<int> position() {
    // TODO: implement position
  }

  @override
  int positionSync() {
    // TODO: implement positionSync
  }

  @override
  Future<List<int>> read(int bytes) {
    // TODO: implement read
  }

  @override
  Future<int> readByte() {
    // TODO: implement readByte
  }

  @override
  int readByteSync() {
    // TODO: implement readByteSync
  }

  @override
  Future<int> readInto(List<int> buffer, [int start = 0, int end]) {
    // TODO: implement readInto
  }

  @override
  int readIntoSync(List<int> buffer, [int start = 0, int end]) {
    // TODO: implement readIntoSync
  }

  @override
  List<int> readSync(int bytes) {
    // TODO: implement readSync
  }

  @override
  Future<RandomAccessFile> setPosition(int position) {
    // TODO: implement setPosition
  }

  @override
  void setPositionSync(int position) {
    // TODO: implement setPositionSync
  }

  @override
  Future<RandomAccessFile> truncate(int length) {
    // TODO: implement truncate
  }

  @override
  void truncateSync(int length) {
    // TODO: implement truncateSync
  }

  @override
  Future<RandomAccessFile> unlock([int start = 0, int end = -1]) {
    // TODO: implement unlock
  }

  @override
  void unlockSync([int start = 0, int end = -1]) {
    // TODO: implement unlockSync
  }

  @override
  Future<RandomAccessFile> writeByte(int value) {
    // TODO: implement writeByte
  }

  @override
  int writeByteSync(int value) {
    // TODO: implement writeByteSync
  }

  @override
  Future<RandomAccessFile> writeFrom(List<int> buffer,
      [int start = 0, int end]) {
    // TODO: implement writeFrom
  }

  @override
  void writeFromSync(List<int> buffer, [int start = 0, int end]) {
    // TODO: implement writeFromSync
  }

  @override
  Future<RandomAccessFile> writeString(String string,
      {Encoding encoding: UTF8}) {
    // TODO: implement writeString
  }

  @override
  void writeStringSync(String string, {Encoding encoding: UTF8}) {
    // TODO: implement writeStringSync
  }
}
