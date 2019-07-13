// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:node_interop/buffer.dart';
import 'package:node_interop/fs.dart';
import 'package:node_interop/js.dart';
import 'package:node_interop/path.dart' as nodePath;
import 'package:node_interop/util.dart';

import 'file_system_entity.dart';
import 'streams.dart';

class _ReadStream extends ReadableStream<Uint8List> {
  _ReadStream(ReadStream nativeStream)
      : super(nativeStream, convert: (chunk) => new Uint8List.fromList(chunk));
}

class _WriteStream extends NodeIOSink {
  _WriteStream(WriteStream nativeStream, Encoding encoding)
      : super(nativeStream, encoding: encoding);
}

/// A reference to a file on the file system.
///
/// A File instance is an object that holds a [path] on which operations can
/// be performed.
/// You can get the parent directory of the file using the getter [parent],
/// a property inherited from [FileSystemEntity].
///
/// Create a new File object with a pathname to access the specified file on the
/// file system from your program.
///
///     var myFile = new File('file.txt');
///
/// The File class contains methods for manipulating files and their contents.
/// Using methods in this class, you can open and close files, read to and write
/// from them, create and delete them, and check for their existence.
///
/// When reading or writing a file, you can use streams (with [openRead]),
/// random access operations (with [open]),
/// or convenience methods such as [readAsString],
///
/// Most methods in this class occur in synchronous and asynchronous pairs,
/// for example, [readAsString] and [readAsStringSync].
/// Unless you have a specific reason for using the synchronous version
/// of a method, prefer the asynchronous version to avoid blocking your program.
///
/// ## If path is a link
///
/// If [path] is a symbolic link, rather than a file,
/// then the methods of File operate on the ultimate target of the
/// link, except for [delete] and [deleteSync], which operate on
/// the link.
///
/// ## Read from a file
///
/// The following code sample reads the entire contents from a file as a string
/// using the asynchronous [readAsString] method:
///
///     import 'dart:async';
///
///     import 'package:node_io/node_io.dart';
///
///     void main() {
///       new File('file.txt').readAsString().then((String contents) {
///         print(contents);
///       });
///     }
///
/// A more flexible and useful way to read a file is with a [Stream].
/// Open the file with [openRead], which returns a stream that
/// provides the data in the file as chunks of bytes.
/// Listen to the stream for data and process as needed.
/// You can use various transformers in succession to manipulate the
/// data into the required format or to prepare it for output.
///
/// You might want to use a stream to read large files,
/// to manipulate the data with transformers,
/// or for compatibility with another API.
///
///     import 'dart:convert';
///     import 'dart:async';
///
///     import 'package:node_io/node_io.dart';
///
///     main() {
///       final file = new File('file.txt');
///       Stream<List<int>> inputStream = file.openRead();
///
///       inputStream
///         .transform(utf8.decoder)       // Decode bytes to UTF-8.
///         .transform(new LineSplitter()) // Convert stream to individual lines.
///         .listen((String line) {        // Process results.
///             print('$line: ${line.length} bytes');
///           },
///           onDone: () { print('File is now closed.'); },
///           onError: (e) { print(e.toString()); });
///     }
///
/// ## Write to a file
///
/// To write a string to a file, use the [writeAsString] method:
///
///     import 'package:node_io/node_io.dart';
///
///     void main() {
///       final filename = 'file.txt';
///       new File(filename).writeAsString('some content')
///         .then((File file) {
///           // Do something with the file.
///         });
///     }
///
/// You can also write to a file using a [Stream]. Open the file with
/// [openWrite], which returns an [io.IOSink] to which you can write data.
/// Be sure to close the sink with the [io.IOSink.close] method.
///
///     import 'package:node_io/node_io.dart';
///
///     void main() {
///       var file = new File('file.txt');
///       var sink = file.openWrite();
///       sink.write('FILE ACCESSED ${new DateTime.now()}\n');
///
///       // Close the IOSink to free system resources.
///       sink.close();
///     }
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
    final fd = fs.openSync(_absolutePath, "w");
    fs.closeSync(fd);
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
    if (recursive) {
      throw new UnsupportedError(
          'Recursive delete is not supported by Node API');
    }
    fs.unlinkSync(_absolutePath);
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
  Stream<Uint8List> openRead([int start, int end]) {
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
  Future<Uint8List> readAsBytes() => openRead()
      .fold(new List<int>(),
          (List<int> previous, List<int> element) => previous..addAll(element))
      .then((List<int> list) => new Uint8List.fromList(list));

  @override
  Uint8List readAsBytesSync() {
    final List<int> buffer = fs.readFileSync(path);
    return new Uint8List.fromList(buffer);
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding: utf8}) {
    return encoding.decoder
        .bind(openRead())
        .transform(new LineSplitter())
        .toList();
  }

  @override
  List<String> readAsLinesSync({Encoding encoding: utf8}) {
    return utf8.decode(readAsBytesSync()).split('\n');
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
  Future<void> setLastAccessed(DateTime time) async {
    return _utimes(atime: new Date(time.millisecondsSinceEpoch));
  }

  @override
  void setLastAccessedSync(DateTime time) {
    _utimesSync(atime: new Date(time.millisecondsSinceEpoch));
  }

  @override
  Future<void> setLastModified(DateTime time) async {
    return _utimes(mtime: new Date(time.millisecondsSinceEpoch));
  }

  @override
  void setLastModifiedSync(DateTime time) {
    _utimesSync(mtime: new Date(time.millisecondsSinceEpoch));
  }

  Future<void> _utimes({Date atime, Date mtime}) async {
    final currentStat = await stat();
    atime ??= new Date(currentStat.accessed.millisecondsSinceEpoch);
    mtime ??= new Date(currentStat.modified.millisecondsSinceEpoch);

    final Completer<void> completer = new Completer();
    void cb([err]) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete();
      }
    }

    final jsCallback = js.allowInterop(cb);
    fs.utimes(_absolutePath, atime, mtime, jsCallback);
    return completer.future;
  }

  void _utimesSync({Date atime, Date mtime}) {
    final currentStat = statSync();
    atime ??= new Date(currentStat.accessed.millisecondsSinceEpoch);
    mtime ??= new Date(currentStat.modified.millisecondsSinceEpoch);
    fs.utimesSync(_absolutePath, atime, mtime);
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
    var flag = _RandomAccessFile.fileModeToJsFlags(mode);
    var options = jsify({"flag": flag});
    fs.writeFileSync(_absolutePath, Buffer.from(bytes), options);
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

  bool _asyncDispatched = false;
  int _position = 0;

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
    return _dispatch(() {
      var completer = new Completer<io.RandomAccessFile>();
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
    });
  }

  @override
  void closeSync() {
    _checkAvailable();
    fs.closeSync(fd);
  }

  @override
  Future<io.RandomAccessFile> flush() {
    return _dispatch(() {
      return new Future.value(this);
    });
  }

  @override
  void flushSync() {
    _checkAvailable(); // Still check for async ops for consistency.
    // no-op
  }

  @override
  Future<int> length() {
    return _dispatch(() {
      File file = new File(path);
      return file.stat().then((stat) => stat.size);
    });
  }

  @override
  int lengthSync() {
    _checkAvailable();
    File file = new File(path);
    return file.statSync().size;
  }

  @override
  Future<io.RandomAccessFile> lock(
      [io.FileLock mode = io.FileLock.exclusive, int start = 0, int end = -1]) {
    throw new UnsupportedError("File locks are not supported by Node.js");
  }

  @override
  void lockSync(
      [io.FileLock mode = io.FileLock.exclusive, int start = 0, int end = -1]) {
    throw new UnsupportedError("File locks are not supported by Node.js");
  }

  @override
  Future<int> position() {
    return _dispatch(() => new Future<int>.value(_position));
  }

  @override
  int positionSync() {
    _checkAvailable();
    return _position;
  }

  @override
  Future<Uint8List> read(int bytes) {
    return _dispatch(() {
      var buffer = Buffer.alloc(bytes);
      final completer = new Completer<Uint8List>();
      void cb(err, bytesRead, buffer) {
        if (err != null) {
          completer.completeError(err);
        } else {
          assert(bytesRead == bytes);
          _position += bytes;
          completer.complete(new Uint8List.fromList(buffer));
        }
      }

      final jsCallback = js.allowInterop(cb);
      fs.read(fd, buffer, 0, bytes, _position, jsCallback);
      return completer.future;
    });
  }

  @override
  Future<int> readByte() {
    return read(1).then((bytes) => bytes.single);
  }

  @override
  int readByteSync() {
    _checkAvailable();
    return readSync(1).single;
  }

  @override
  Future<int> readInto(List<int> buffer, [int start = 0, int end]) {
    end ??= buffer.length;
    var bytes = end - start;
    if (bytes == 0) return new Future.value(0);
    return read(bytes).then((readBytes) {
      buffer.setRange(start, end, readBytes);
      return readBytes.length;
    });
  }

  @override
  int readIntoSync(List<int> buffer, [int start = 0, int end]) {
    _checkAvailable();
    end ??= buffer.length;
    var bytes = end - start;
    if (bytes == 0) return 0;
    var readBytes = readSync(bytes);
    buffer.setRange(start, end, readBytes);
    return bytes;
  }

  @override
  Uint8List readSync(int bytes) {
    _checkAvailable();
    Object buffer = Buffer.alloc(bytes);
    final bytesRead = fs.readSync(fd, buffer, 0, bytes, _position);
    assert(bytesRead == bytes);
    _position += bytes;
    return new Uint8List.fromList(buffer);
  }

  @override
  Future<io.RandomAccessFile> setPosition(int position) {
    throw new UnsupportedError("Setting position is not supported by Node.js");
  }

  @override
  void setPositionSync(int position) {
    throw new UnsupportedError("Setting position is not supported by Node.js");
  }

  @override
  Future<io.RandomAccessFile> truncate(int length) {
    return _dispatch(() {
      final completer = new Completer<io.RandomAccessFile>();
      void cb([err]) {
        if (err != null) {
          completer.completeError(err);
        } else {
          completer.complete(this);
        }
      }

      final jsCallback = js.allowInterop(cb);
      fs.ftruncate(fd, length, jsCallback);
      return completer.future;
    });
  }

  @override
  void truncateSync(int length) {
    _checkAvailable();
    fs.ftruncateSync(fd, length);
  }

  @override
  Future<io.RandomAccessFile> unlock([int start = 0, int end = -1]) {
    throw new UnsupportedError("File locks are not supported by Node.js");
  }

  @override
  void unlockSync([int start = 0, int end = -1]) {
    throw new UnsupportedError("File locks are not supported by Node.js");
  }

  @override
  Future<io.RandomAccessFile> writeByte(int value) {
    return _dispatch(() {
      final completer = new Completer<io.RandomAccessFile>();
      void cb(err, bytesWritten, buffer) {
        if (err != null) {
          completer.completeError(err);
        } else {
          completer.complete(this);
        }
      }

      final jsCallback = js.allowInterop(cb);
      fs.write(fd, Buffer.from([value]), jsCallback);
      return completer.future;
    });
  }

  @override
  int writeByteSync(int value) {
    _checkAvailable();
    return fs.writeSync(fd, Buffer.from([value]));
  }

  @override
  Future<io.RandomAccessFile> writeFrom(List<int> buffer,
      [int start = 0, int end]) {
    return _dispatch(() {
      final completer = new Completer<io.RandomAccessFile>();
      void cb(err, bytesWritten, buffer) {
        if (err != null) {
          completer.completeError(err);
        } else {
          completer.complete(this);
        }
      }

      final jsCallback = js.allowInterop(cb);
      end ??= buffer.length;
      final length = end - start;
      fs.write(fd, Buffer.from(buffer), start, length, jsCallback);
      return completer.future;
    });
  }

  @override
  void writeFromSync(List<int> buffer, [int start = 0, int end]) {
    _checkAvailable();
    end ??= buffer.length;
    final length = end - start;
    fs.writeSync(fd, Buffer.from(buffer), start, length);
  }

  @override
  Future<io.RandomAccessFile> writeString(String string,
      {Encoding encoding: utf8}) {
    return writeFrom(encoding.encode(string));
  }

  @override
  void writeStringSync(String string, {Encoding encoding: utf8}) {
    _checkAvailable();
    writeFromSync(encoding.encode(string));
  }

  bool _closed = false;

  Future<T> _dispatch<T>(Future<T> request(), {bool markClosed: false}) {
    if (_closed) {
      return new Future.error(new io.FileSystemException("File closed", path));
    }
    if (_asyncDispatched) {
      var msg = "An async operation is currently pending";
      return new Future.error(new io.FileSystemException(msg, path));
    }
    if (markClosed) {
      // Set closed to true to ensure that no more async requests can be issued
      // for this file.
      _closed = true;
    }
    _asyncDispatched = true;

    return request().whenComplete(() {
      _asyncDispatched = false;
    });
  }

  void _checkAvailable() {
    if (_asyncDispatched) {
      throw new io.FileSystemException(
          "An async operation is currently pending", path);
    }
    if (_closed) {
      throw new io.FileSystemException("File closed", path);
    }
  }
}
