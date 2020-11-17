// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:file/file.dart' as file;
import 'package:node_interop/fs.dart';
import 'package:node_interop/path.dart' as node_path;

import 'directory.dart';
import 'file_system_entity.dart';

/// Link objects are references to filesystem links.
class Link extends FileSystemEntity implements file.Link {
  @override
  final String path;

  Link(this.path);

  factory Link.fromRawPath(Uint8List rawPath) {
    // TODO: implement fromRawPath
    throw UnimplementedError();
  }

  /// Creates a [Link] object.
  ///
  /// If [path] is a relative path, it will be interpreted relative to the
  /// current working directory (see [Directory.current]), when used.
  ///
  /// If [path] is an absolute path, it will be immune to changes to the
  /// current working directory.
  factory Link.fromUri(Uri uri) => Link(uri.toFilePath());

  @override
  Future<bool> exists() async {
    var stat = await FileStat.stat(path);
    return stat.type == io.FileSystemEntityType.link;
  }

  @override
  bool existsSync() {
    var stat = FileStat.statSync(path);
    return stat.type == io.FileSystemEntityType.link;
  }

  @override
  Link get absolute => Link(_absolutePath);

  String get _absolutePath => node_path.path.resolve(path);

  @override
  Future<Link> create(String target, {bool recursive = false}) {
    if (recursive) {
      throw UnsupportedError('Recursive flag not supported by Node.js');
    }

    final completer = Completer<Link>();
    void cb([err]) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(this);
      }
    }

    final jsCallback = js.allowInterop(cb);
    fs.symlink(target, path, jsCallback);
    return completer.future;
  }

  @override
  void createSync(String target, {bool recursive = false}) {
    if (recursive) {
      throw UnsupportedError('Recursive flag not supported by Node.js');
    }
    fs.symlinkSync(target, path);
  }

  @override
  Future<Link> delete({bool recursive = false}) {
    if (recursive) {
      return Future.error(
          UnsupportedError('Recursive flag is not supported by Node.js'));
    }
    final completer = Completer<Link>();
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
  void deleteSync({bool recursive = false}) {
    if (recursive) {
      throw UnsupportedError('Recursive flag is not supported by Node.js');
    }
    fs.unlinkSync(_absolutePath);
  }

  @override
  Future<Link> rename(String newPath) {
    final completer = Completer<Link>();
    void cb(err) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(Link(newPath));
      }
    }

    final jsCallback = js.allowInterop(cb);
    fs.rename(path, newPath, jsCallback);
    return completer.future;
  }

  @override
  Link renameSync(String newPath) {
    fs.renameSync(path, newPath);
    return Link(newPath);
  }

  @override
  Future<String> target() {
    final completer = Completer<String>();
    void cb(err, String target) {
      if (err != null) {
        completer.completeError(err);
      } else {
        completer.complete(target);
      }
    }

    final jsCallback = js.allowInterop(cb);
    fs.readlink(path, jsCallback);
    return completer.future;
  }

  @override
  String targetSync() {
    return fs.readlinkSync(path);
  }

  @override
  Future<Link> update(String target) {
    return delete().then((link) => link.create(target));
  }

  @override
  void updateSync(String target) {
    deleteSync();
    createSync(target);
  }
}
