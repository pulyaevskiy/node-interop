// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:js' as js;

import 'package:node_interop/fs.dart';
import 'package:node_interop/node.dart';
import 'package:node_interop/path.dart' as nodePath;
import 'package:node_interop/os.dart';
import 'package:path/path.dart';

import 'file.dart';
import 'file_system_entity.dart';
import 'link.dart';
import 'platform.dart';

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

  static io.Directory get systemTemp {
    return new Directory(os.tmpdir());
  }

  @override
  io.Directory get absolute => new Directory(nodePath.path.resolve(path));

  @override
  Future<bool> exists() => FileStat.stat(path)
      .then((stat) => stat.type == io.FileSystemEntityType.directory);

  @override
  bool existsSync() =>
      FileStat.statSync(path).type == io.FileSystemEntityType.directory;

  @override
  Future<io.FileSystemEntity> delete({bool recursive: false}) {
    if (recursive)
      return new Future.error(new UnsupportedError(
          'Recursive delete is not supported by Node API'));
    final completer = new Completer<Directory>();

    void callback([error]) {
      if (error == null) {
        completer.complete(this);
      } else {
        completer.completeError(error);
      }
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
  Stream<FileSystemEntity> list(
      {bool recursive: false, bool followLinks: true}) {
    if (recursive)
      throw new UnsupportedError('Recursive list is not supported in Node.');
    final controller = new StreamController<FileSystemEntity>();

    void callback(err, [files]) {
      if (err != null) {
        controller.addError(err);
        controller.close();
      } else {
        for (var filePath in files) {
          // Need to append the original path to build a proper path
          filePath = join(path, filePath);
          final stat = FileStat.statSync(filePath);
          if (stat.type == io.FileSystemEntityType.file) {
            controller.add(new File(filePath));
          } else if (stat.type == io.FileSystemEntityType.directory) {
            controller.add(new Directory(filePath));
          } else {
            controller.add(new Link(filePath));
          }
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
  Future<Directory> create({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError('Recursive create is not supported in Node.');
    final completer = new Completer<Directory>();
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
    prefix ??= '';
    if (path == '') {
      throw new ArgumentError("Directory.createTemp called with an empty path. "
          "To use the system temp directory, use Directory.systemTemp");
    }
    String fullPrefix;
    if (path.endsWith('/') || (Platform.isWindows && path.endsWith('\\'))) {
      fullPrefix = "$path$prefix";
    } else {
      fullPrefix = "$path${Platform.pathSeparator}$prefix";
    }

    final completer = new Completer<Directory>();
    void callback(err, result) {
      if (err == null) {
        completer.complete(new Directory(result));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);

    fs.mkdtemp(fullPrefix, jsCallback);
    return completer.future;
  }

  @override
  io.Directory createTempSync([String prefix]) {
    prefix ??= '';
    if (path == '') {
      throw new ArgumentError("Directory.createTemp called with an empty path. "
          "To use the system temp directory, use Directory.systemTemp");
    }
    String fullPrefix;
    if (path.endsWith('/') || (Platform.isWindows && path.endsWith('\\'))) {
      fullPrefix = "$path$prefix";
    } else {
      fullPrefix = "$path${Platform.pathSeparator}$prefix";
    }
    final resultPath = fs.mkdtempSync(fullPrefix);
    return new Directory(resultPath);
  }

  @override
  List<io.FileSystemEntity> listSync(
      {bool recursive: false, bool followLinks: true}) {
    if (recursive)
      throw new UnsupportedError('Recursive list is not supported in Node.js.');

    final files = fs.readdirSync(path);
    return files.map((filePath) {
      // Need to append the original path to build a proper path
      filePath = join(path, filePath);
      final stat = FileStat.statSync(filePath);
      if (stat.type == io.FileSystemEntityType.file) {
        return new File(filePath);
      } else if (stat.type == io.FileSystemEntityType.directory) {
        return new Directory(filePath);
      } else {
        return new Link(filePath);
      }
    }).toList();
  }
}
