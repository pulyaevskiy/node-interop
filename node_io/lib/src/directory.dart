// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'package:js/js.dart' as js;
import 'package:node_interop/node.dart';
import 'package:node_interop/fs.dart';
import 'package:node_interop/path.dart' as nodePath;

import 'file.dart';
import 'file_system_entity.dart';

class Directory extends FileSystemEntity implements io.Directory {
  @override
  final String path;

  Directory(this.path);

  static io.Directory get current => new Directory(process.cwd());

  static void set current(path) {
    path = (path is io.Directory) ? path.path : path;
    assert(path is String);
    process.chdir(path);
  }

  @override
  String toString() => "Directory: '$path'";

  @override
  io.Directory get absolute => new Directory(nodePath.path.resolve(path));

  @override
  Future<bool> exists() => FileStat
      .stat(path)
      .then((stat) => stat.type == io.FileSystemEntityType.DIRECTORY);

  @override
  bool existsSync() =>
      FileStat.statSync(path).type == io.FileSystemEntityType.DIRECTORY;

  @override
  Future<io.Directory> delete({bool recursive: false}) {
    if (recursive)
      return new Future.error(new UnsupportedError(
          'Recursive delete is not supported by Node API'));
    final completer = new Completer<io.FileSystemEntity>();

    void callback([error]) {
      if (error == null) {
        completer.complete(this);
      }
      completer.completeError(error);
    }

    final jsCallback = js.allowInterop(callback);
    fs.rmdir(path, jsCallback);
    return completer.future;
  }

  @override
  void deleteSync({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError('Recursive delete is not supported in Node.');
    fs.rmdirSync(path);
  }

  @override
  Stream<io.FileSystemEntity> list(
      {bool recursive: false, bool followLinks: true}) {
    final controller = new StreamController<FileSystemEntity>();

    void callback(err, files) {
      if (err != null) {
        controller.addError(err);
        controller.close();
      } else {
        for (var filePath in files) {
          controller.add(new File(filePath));
        }
        controller.close();
      }
    }

    fs.readdir(path, js.allowInterop(callback));

    return controller.stream;
  }

  @override
  Future<io.Directory> rename(String newPath) {
    final completer = new Completer<Directory>();
    void callback(err) {
      if (err == null) {
        completer.complete(new Directory(newPath));
      } else {
        completer.completeError(err);
      }
    }

    final jsCallback = js.allowInterop(callback);

    fs.rename(path, newPath, jsCallback);
    return completer.future;
  }

  @override
  io.Directory renameSync(String newPath) {
    fs.renameSync(path, newPath);
    return new Directory(newPath);
  }

  @override
  Future<io.Directory> create({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError('Recursive create is not supported in Node.');
    final completer = new Completer();
    void callback(err) {
      if (err == null) {
        completer.complete(new Directory(path));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);

    fs.mkdir(path, jsCallback);
    return completer.future;
  }

  @override
  void createSync({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError('Recursive create is not supported in Node.');
    fs.mkdirSync(path);
  }

  @override
  Future<io.Directory> createTemp([String prefix]) {
    throw new UnimplementedError();
  }

  @override
  io.Directory createTempSync([String prefix]) {
    throw new UnimplementedError();
  }

  @override
  List<io.FileSystemEntity> listSync(
      {bool recursive: false, bool followLinks: true}) {
    throw new UnimplementedError();
  }
}
