// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.fs;

import 'package:js/js.dart';
import 'globals.dart';

FS _fs;
FS get nodeFS {
  if (_fs != null) return _fs;
  _fs = require('fs');
  return _fs;
}

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
  external JsDate get atime;
  external JsDate get ctime;
  external JsDate get mtime;
  external num get atimeMs; // since 8.1.0
  external num get ctimeMs; // since 8.1.0
  external num get mtimeMs; // since 8.1.0
}
