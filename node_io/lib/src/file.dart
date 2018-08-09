// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:js' as js;

import 'package:node_interop/fs.dart';
import 'package:node_interop/path.dart' as nodePath;

import 'file_system_entity.dart';
import 'streams.dart';

class _ReadStream extends ReadableStream<List<int>> {
  _ReadStream(ReadStream nativeStream)
      : super(nativeStream, convert: (chunk) => new List.unmodifiable(chunk));
}

class _WriteStream extends NodeIOSink {
  _WriteStream(WriteStream nativeStream, Encoding encoding)
      : super(nativeStream, encoding: encoding);
}

class File extends FileSystemEntity implements io.File {
  @override
  final String path;

  File(this.path);

  @override
  File get absolute => new File(_absolutePath);

  String get _absolutePath => nodePath.path.resolve(path);

  @override
  Future<File> copy(String newPath) {
    final Completer<File> completer = new Completer<File>();
    void callback(err) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(new File(newPath));
      }
    }

    final jsCallback = js.allowInterop(callback);
    fs.copyFile(_absolutePath, newPath, 0, jsCallback);
    return completer.future;
  }

  @override
  File copySync(String newPath) {
    fs.copyFileSync(_absolutePath, newPath, 0);
    return new File(newPath);
  }

  @override
  Future<File> create({bool recursive: false}) {
    // write an empty file
    final Completer<File> completer = new Completer<File>();
    void callback(err, [fd]) {
      if (err != null) {
        completer.completeError(err);
      } else {
        fs.close(fd, js.allowInterop((err) {
          if (err != null) {
            completer.completeError(err);
          } else {
            completer.complete(this);
          }
        }));
      }
    }

    final jsCallback = js.allowInterop(callback);
    fs.open(_absolutePath, "w", jsCallback);
    return completer.future;
  }

  @override
  void createSync({bool recursive: false}) {
    // TODO: implement createSync
    throw new UnimplementedError();
  }

  @override
  Future<io.FileSystemEntity> delete({bool recursive: false}) {
    if (recursive) {
      return new Future.error(new UnsupportedError(
          'Recursive delete is not supported by Node API'));
    }
    final Completer<File> completer = new Completer<File>();
    void callback(err) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(this);
      }
    }

    final jsCallback = js.allowInterop(callback);
    fs.unlink(_absolutePath, jsCallback);
    return completer.future;
  }

  @override
  void deleteSync({bool recursive: false}) {
    // TODO: implement deleteSync
    throw new UnimplementedError();
  }

  @override
  Future<bool> exists() async {
    var stat = await FileStat.stat(path);
    return stat.type == io.FileSystemEntityType.file;
  }

  @override
  bool existsSync() {
    var stat = FileStat.statSync(path);
    return stat.type == io.FileSystemEntityType.file;
  }

  @override
  Future<DateTime> lastAccessed() =>
      FileStat.stat(path).then((_) => _.accessed);

  @override
  DateTime lastAccessedSync() => FileStat.statSync(path).accessed;

  @override
  Future<DateTime> lastModified() =>
      FileStat.stat(path).then((_) => _.modified);

  @override
  DateTime lastModifiedSync() => FileStat.statSync(path).modified;

  @override
  Future<int> length() => FileStat.stat(path).then((_) => _.size);

  @override
  int lengthSync() => FileStat.statSync(path).size;

  @override
  Future<io.RandomAccessFile> open({io.FileMode mode: io.FileMode.read}) =>
      _RandomAccessFile.open(path, mode);

  @override
  Stream<List<int>> openRead([int start, int end]) {
    var options = new ReadStreamOptions();
    if (start != null) options.start = start;
    if (end != null) options.end = end;
    var nativeStream = fs.createReadStream(path, options);
    return new _ReadStream(nativeStream);
  }

  @override
  io.RandomAccessFile openSync({io.FileMode mode: io.FileMode.read}) =>
      _RandomAccessFile.openSync(path, mode);

  @override
  io.IOSink openWrite(
      {io.FileMode mode: io.FileMode.write, Encoding encoding: utf8}) {
    assert(mode == io.FileMode.write || mode == io.FileMode.append);
    var flags = (mode == io.FileMode.append) ? 'a+' : 'w';
    var options = new WriteStreamOptions(flags: flags);
    var stream = fs.createWriteStream(path, options);
    return new _WriteStream(stream, encoding);
  }

  @override
  Future<List<int>> readAsBytes() => openRead().fold(new List<int>(),
      (List<int> previous, List<int> element) => previous..addAll(element));

  @override
  List<int> readAsBytesSync() {
    final List<int> buffer = fs.readFileSync(path);

    return buffer;
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding: utf8}) {
    // TODO: implement readAsLines
    throw new UnimplementedError();
  }

  @override
  List<String> readAsLinesSync({Encoding encoding: utf8}) {
    // TODO: implement readAsLinesSync
    throw new UnimplementedError();
  }

  @override
  Future<String> readAsString({Encoding encoding: utf8}) async {
    var bytes = await readAsBytes();
    return encoding.decode(bytes);
  }

  @override
  String readAsStringSync({Encoding encoding: utf8}) {
    return encoding.decode(readAsBytesSync());
  }

  @override
  Future<File> rename(String newPath) {
    final completer = new Completer<File>();
    void cb(err) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(new File(newPath));
      }
    }

    final jsCallback = js.allowInterop(cb);
    fs.rename(path, newPath, jsCallback);
    return completer.future;
  }

  @override
  File renameSync(String newPath) {
    fs.renameSync(path, newPath);

    return new File(newPath);
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
  Future<io.File> writeAsBytes(List<int> bytes,
      {io.FileMode mode: io.FileMode.write, bool flush: false}) async {
    var sink = openWrite(mode: mode);
    sink.add(bytes);
    if (flush == true) {
      await sink.flush();
    }
    await sink.close();
    return this;
  }

  @override
  void writeAsBytesSync(List<int> bytes,
      {io.FileMode mode: io.FileMode.write, bool flush: false}) {
    // TODO: implement writeAsBytesSync
    throw new UnimplementedError();
  }

  @override
  Future<io.File> writeAsString(String contents,
      {io.FileMode mode: io.FileMode.write,
      Encoding encoding: utf8,
      bool flush: false}) async {
    var sink = openWrite(mode: mode, encoding: encoding);
    sink.write(contents);
    if (flush == true) {
      await sink.flush();
    }
    await sink.close();
    return this;
  }

  @override
  void writeAsStringSync(String contents,
      {io.FileMode mode: io.FileMode.write,
      Encoding encoding: utf8,
      bool flush: false}) {
    fs.writeFileSync(_absolutePath, contents);
  }
}

class _RandomAccessFile implements io.RandomAccessFile {
  /// File Descriptor
  final int fd;

  /// File path.
  final String path;

  _RandomAccessFile(this.fd, this.path);

  static Future<io.RandomAccessFile> open(String path, io.FileMode mode) {
    final completer = new Completer<_RandomAccessFile>();
    void cb(err, [fd]) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(new _RandomAccessFile(fd, path));
      }
    }

    final jsCallback = js.allowInterop(cb);
    fs.open(path, fileModeToJsFlags(mode), jsCallback);
    return completer.future;
  }

  static io.RandomAccessFile openSync(String path, io.FileMode mode) {
    final fd = fs.openSync(path, fileModeToJsFlags(mode));
    return new _RandomAccessFile(fd, path);
  }

  static String fileModeToJsFlags(io.FileMode mode) {
    switch (mode) {
      case io.FileMode.read:
        return 'r';
      case io.FileMode.write:
        return 'w+';
      case io.FileMode.writeOnly:
        return 'w';
      case io.FileMode.append:
        return 'a+';
      case io.FileMode.writeOnlyAppend:
        return 'a';
      default:
        throw new UnsupportedError('$mode is not supported');
    }
  }

  @override
  Future<io.RandomAccessFile> close() {
    var completer = new Completer();
    void callback(err) {
      if (err == null) {
        completer.complete(this);
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);
    fs.close(fd, jsCallback);
    return completer.future;
  }

  @override
  void closeSync() {
    fs.closeSync(fd);
  }

  @override
  Future<io.RandomAccessFile> flush() => new Future.value(this);

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
  Future<io.RandomAccessFile> lock(
      [io.FileLock mode = io.FileLock.exclusive, int start = 0, int end = -1]) {
    // TODO: implement lock
    throw new UnimplementedError();
  }

  @override
  void lockSync(
      [io.FileLock mode = io.FileLock.exclusive, int start = 0, int end = -1]) {
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
  Future<io.RandomAccessFile> setPosition(int position) {
    // TODO: implement setPosition
    throw new UnimplementedError();
  }

  @override
  void setPositionSync(int position) {
    // TODO: implement setPositionSync
    throw new UnimplementedError();
  }

  @override
  Future<io.RandomAccessFile> truncate(int length) {
    // TODO: implement truncate
    throw new UnimplementedError();
  }

  @override
  void truncateSync(int length) {
    // TODO: implement truncateSync
    throw new UnimplementedError();
  }

  @override
  Future<io.RandomAccessFile> unlock([int start = 0, int end = -1]) {
    // TODO: implement unlock
    throw new UnimplementedError();
  }

  @override
  void unlockSync([int start = 0, int end = -1]) {
    // TODO: implement unlockSync
    throw new UnimplementedError();
  }

  @override
  Future<io.RandomAccessFile> writeByte(int value) {
    // TODO: implement writeByte
    throw new UnimplementedError();
  }

  @override
  int writeByteSync(int value) {
    // TODO: implement writeByteSync
    throw new UnimplementedError();
  }

  @override
  Future<io.RandomAccessFile> writeFrom(List<int> buffer,
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
  Future<io.RandomAccessFile> writeString(String string,
      {Encoding encoding: utf8}) {
    // TODO: implement writeString
    throw new UnimplementedError();
  }

  @override
  void writeStringSync(String string, {Encoding encoding: utf8}) {
    // TODO: implement writeStringSync
    throw new UnimplementedError();
  }
}
