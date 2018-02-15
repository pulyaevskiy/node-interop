// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node FS module bindings.
///
/// Use library-level [fs] object to access functionality of this module.
@JS()
library node_interop.fs;

import 'package:js/js.dart';

import 'node.dart';
import 'stream.dart';

FS get fs => _fs ??= require('fs');
FS _fs;

@JS()
@anonymous
abstract class FS {
  external void readdir(String path, void callback(err, List<String> files));
  external List<String> readdirSync(String path);
  external void rmdir(String path, void callback(err));
  external void rmdirSync(String path);
  external void realpath(path, void callback(err, String path));
  external String realpathSync(path);
  external void stat(String path, void callback(err, Stats stats));
  external Stats statSync(String path);
  external void rename(String oldPath, String newPath, void callback(err));
  external void renameSync(String oldPath, String newPath);
  external void mkdir(String path, void callback(err));
  external void mkdirSync(String path);
  external void close(int fd, void callback(err));
  external void closeSync(int fd);
  external void open(String path, String flags, void callback(err, fd));
  external int openSync(String path, String flags);
  external void writeFileSync(String file, String data, [options]);
  external void copyFile(
      dynamic src, dynamic dest, num flags, void callback(err));
  external void copyFileSync(dynamic src, dynamic dest, num flags);
  external ReadStream createReadStream(dynamic path,
      [ReadStreamOptions options]);
  external WriteStream createWriteStream(dynamic path,
      [WriteStreamOptions options]);
}

@JS()
abstract class ReadStream implements Readable {
  external num get bytesRead;
  external dynamic get path;
}

@JS()
@anonymous
abstract class ReadStreamOptions {
  external String get flags;
  external String get encoding;
  external int get fd;
  external int get mode;
  external bool get autoClose;
  external int get start;
  external set start(int value);
  external int get end;
  external set end(int value);

  external factory ReadStreamOptions({
    String flags,
    String encoding,
    int fd,
    int mode,
    bool autoClose,
    int start,
    int end,
  });
}

@JS()
@anonymous
abstract class WriteStream implements Writable {
  external num get bytesWritten;
  external dynamic get path;
}

@JS()
@anonymous
abstract class WriteStreamOptions {
  external String get flags;
  external String get encoding;
  external int get fd;
  external int get mode;
  external bool get autoClose;
  external int get start;

  external factory WriteStreamOptions({
    String flags,
    String encoding,
    int fd,
    int mode,
    bool autoClose,
    int start,
  });
}

@JS()
@anonymous
abstract class Stats {
  external bool isFile();
  external bool isDirectory();
  external bool isBlockDevice();
  external bool isCharacterDevice();
  external bool isSymbolicLink();
  external bool isFIFO();
  external bool isSocket();

  external int get mode;
  external int get size;
  external Date get atime;
  external Date get ctime;
  external Date get mtime;
  external num get atimeMs; // since 8.1.0
  external num get ctimeMs; // since 8.1.0
  external num get mtimeMs; // since 8.1.0
}
