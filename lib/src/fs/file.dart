// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of node_interop.fs;

class _ReadStream extends ReadableStream<List<int>> {
  _ReadStream(ReadStream nativeStream)
      : super(nativeStream, convert: (chunk) => new List.unmodifiable(chunk));
}

// Note: for some reason analyzer complains if this class does not implement
// [IOSink] explicitly.
class _WriteStream extends NodeIOSink implements IOSink {
  _WriteStream(WriteStream nativeStream, Encoding encoding)
      : super(nativeStream, encoding: encoding);
}

class _File extends _FileSystemEntity implements File {
  @override
  final String path;

  _File(this.path);

  @override
  File get absolute => new _File(_absolutePath);

  @override
  Future<File> copy(String newPath) {
    // TODO: implement copy
    throw new UnimplementedError();
  }

  @override
  File copySync(String newPath) {
    // TODO: implement copySync
    throw new UnimplementedError();
  }

  @override
  Future<File> create({bool recursive: false}) {
    // TODO: implement create
    throw new UnimplementedError();
  }

  @override
  void createSync({bool recursive: false}) {
    // TODO: implement createSync
    throw new UnimplementedError();
  }

  @override
  Future<FileSystemEntity> delete({bool recursive: false}) {
    // TODO: implement delete
    throw new UnimplementedError();
  }

  @override
  void deleteSync({bool recursive: false}) {
    // TODO: implement deleteSync
    throw new UnimplementedError();
  }

  @override
  Future<bool> exists() async {
    var stat = await _FileStat.stat(path);
    return stat.type == FileSystemEntityType.FILE;
  }

  @override
  bool existsSync() {
    var stat = _FileStat.statSync(path);
    return stat.type == FileSystemEntityType.FILE;
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
    var options = new ReadStreamOptions();
    if (start != null) options.start = start;
    if (end != null) options.end = end;
    var nativeStream = _nodeFS.createReadStream(path, options);
    return new _ReadStream(nativeStream);
  }

  @override
  RandomAccessFile openSync({FileMode mode: FileMode.READ}) =>
      _RandomAccessFile.openSync(path, mode);

  @override
  IOSink openWrite({FileMode mode: FileMode.WRITE, Encoding encoding: UTF8}) {
    assert(mode == FileMode.WRITE || mode == FileMode.APPEND);
    var flags = (mode == FileMode.APPEND) ? 'a+' : 'w';
    var options = new WriteStreamOptions(flags: flags);
    var stream = _nodeFS.createWriteStream(path, options);
    return new _WriteStream(stream, encoding);
  }

  @override
  Future<List<int>> readAsBytes() => openRead().fold(new List<int>(),
      (List<int> previous, List<int> element) => previous..addAll(element));

  @override
  List<int> readAsBytesSync() {
    // TODO: implement readAsBytesSync
    throw new UnimplementedError();
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding: UTF8}) {
    // TODO: implement readAsLines
    throw new UnimplementedError();
  }

  @override
  List<String> readAsLinesSync({Encoding encoding: UTF8}) {
    // TODO: implement readAsLinesSync
    throw new UnimplementedError();
  }

  @override
  Future<String> readAsString({Encoding encoding: UTF8}) {
    // TODO: implement readAsString
    throw new UnimplementedError();
  }

  @override
  String readAsStringSync({Encoding encoding: UTF8}) {
    // TODO: implement readAsStringSync
    throw new UnimplementedError();
  }

  @override
  Future<File> rename(String newPath) {
    // TODO: implement rename
    throw new UnimplementedError();
  }

  @override
  File renameSync(String newPath) {
    // TODO: implement renameSync
    throw new UnimplementedError();
  }

  @override
  Future setLastAccessed(DateTime time) {
    // TODO: implement setLastAccessed
    throw new UnimplementedError();
  }

  @override
  void setLastAccessedSync(DateTime time) {
    // TODO: implement setLastAccessedSync
    throw new UnimplementedError();
  }

  @override
  Future setLastModified(DateTime time) {
    // TODO: implement setLastModified
    throw new UnimplementedError();
  }

  @override
  void setLastModifiedSync(DateTime time) {
    // TODO: implement setLastModifiedSync
    throw new UnimplementedError();
  }

  @override
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode: FileMode.WRITE, bool flush: false}) {
    // TODO: implement writeAsBytes
    throw new UnimplementedError();
  }

  @override
  void writeAsBytesSync(List<int> bytes,
      {FileMode mode: FileMode.WRITE, bool flush: false}) {
    // TODO: implement writeAsBytesSync
    throw new UnimplementedError();
  }

  @override
  Future<File> writeAsString(String contents,
      {FileMode mode: FileMode.WRITE,
      Encoding encoding: UTF8,
      bool flush: false}) {
    // TODO: implement writeAsString
    throw new UnimplementedError();
  }

  @override
  void writeAsStringSync(String contents,
      {FileMode mode: FileMode.WRITE,
      Encoding encoding: UTF8,
      bool flush: false}) {
    _nodeFS.writeFileSync(_absolutePath, contents);
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
    _nodeFS.open(path, fileModeToJsFlags(mode), jsCallback);
    return completer.future;
  }

  static _RandomAccessFile openSync(String path, FileMode mode) {
    var fd = _nodeFS.openSync(path, fileModeToJsFlags(mode));
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
    _nodeFS.close(fd, jsCallback);
    return completer.future;
  }

  @override
  void closeSync() {
    _nodeFS.closeSync(fd);
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
    throw new UnimplementedError();
  }

  @override
  int lengthSync() {
    // TODO: implement lengthSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> lock(
      [FileLock mode = FileLock.EXCLUSIVE, int start = 0, int end = -1]) {
    // TODO: implement lock
    throw new UnimplementedError();
  }

  @override
  void lockSync(
      [FileLock mode = FileLock.EXCLUSIVE, int start = 0, int end = -1]) {
    // TODO: implement lockSync
    throw new UnimplementedError();
  }

  @override
  Future<int> position() {
    // TODO: implement position
    throw new UnimplementedError();
  }

  @override
  int positionSync() {
    // TODO: implement positionSync
    throw new UnimplementedError();
  }

  @override
  Future<List<int>> read(int bytes) {
    // TODO: implement read
    throw new UnimplementedError();
  }

  @override
  Future<int> readByte() {
    // TODO: implement readByte
    throw new UnimplementedError();
  }

  @override
  int readByteSync() {
    // TODO: implement readByteSync
    throw new UnimplementedError();
  }

  @override
  Future<int> readInto(List<int> buffer, [int start = 0, int end]) {
    // TODO: implement readInto
    throw new UnimplementedError();
  }

  @override
  int readIntoSync(List<int> buffer, [int start = 0, int end]) {
    // TODO: implement readIntoSync
    throw new UnimplementedError();
  }

  @override
  List<int> readSync(int bytes) {
    // TODO: implement readSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> setPosition(int position) {
    // TODO: implement setPosition
    throw new UnimplementedError();
  }

  @override
  void setPositionSync(int position) {
    // TODO: implement setPositionSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> truncate(int length) {
    // TODO: implement truncate
    throw new UnimplementedError();
  }

  @override
  void truncateSync(int length) {
    // TODO: implement truncateSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> unlock([int start = 0, int end = -1]) {
    // TODO: implement unlock
    throw new UnimplementedError();
  }

  @override
  void unlockSync([int start = 0, int end = -1]) {
    // TODO: implement unlockSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> writeByte(int value) {
    // TODO: implement writeByte
    throw new UnimplementedError();
  }

  @override
  int writeByteSync(int value) {
    // TODO: implement writeByteSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> writeFrom(List<int> buffer,
      [int start = 0, int end]) {
    // TODO: implement writeFrom
    throw new UnimplementedError();
  }

  @override
  void writeFromSync(List<int> buffer, [int start = 0, int end]) {
    // TODO: implement writeFromSync
    throw new UnimplementedError();
  }

  @override
  Future<RandomAccessFile> writeString(String string,
      {Encoding encoding: UTF8}) {
    // TODO: implement writeString
    throw new UnimplementedError();
  }

  @override
  void writeStringSync(String string, {Encoding encoding: UTF8}) {
    // TODO: implement writeStringSync
    throw new UnimplementedError();
  }
}
