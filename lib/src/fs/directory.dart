// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of node_interop.fs;

class _Directory extends _FileSystemEntity implements Directory {
  @override
  final String path;

  _Directory(this.path);

  @override
  String toString() => "Directory: '$path'";

  @override
  Directory get absolute => new _Directory(_absolutePath);

  @override
  Future<bool> exists() async {
    var stat = await _FileStat.stat(path);
    return stat.type == FileSystemEntityType.DIRECTORY;
  }

  @override
  bool existsSync() {
    var stat = _FileStat.statSync(path);
    return stat.type == FileSystemEntityType.DIRECTORY;
  }

  @override
  Future<Directory> delete({bool recursive: false}) {
    if (recursive)
      return new Future.error(new UnsupportedError(
          'Recursive delete is not supported by Node API'));
    var completer = new Completer<FileSystemEntity>();
    void callback(error) {
      if (error == null) {
        completer.complete(this);
      }
      completer.completeError(error);
    }

    var jsCallback = js.allowInterop(callback);
    nodeFS.rmdir(path, jsCallback);
    return completer.future;
  }

  @override
  void deleteSync({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError(
          'Recursive delete is not supported by Node API');
    nodeFS.rmdirSync(path);
  }

  @override
  Stream<FileSystemEntity> list(
      {bool recursive: false, bool followLinks: true}) {
    var controller = new StreamController<FileSystemEntity>();

    void callback(err, files) {
      if (err != null) {
        controller.addError(err);
        controller.close();
      } else {
        for (var file in files) {
          // TODO: create proper entity objects
          controller.add(file);
        }
        controller.close();
      }
    }

    nodeFS.readdir(path, js.allowInterop(callback));

    return controller.stream;
  }

  @override
  Future<Directory> rename(String newPath) {
    var completer = new Completer<Directory>();
    void callback(err) {
      if (err == null) {
        completer.complete(new _Directory(newPath));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);

    nodeFS.rename(path, newPath, jsCallback);
    return completer.future;
  }

  @override
  Directory renameSync(String newPath) {
    nodeFS.renameSync(path, newPath);
    return new _Directory(newPath);
  }

  @override
  Directory childDirectory(String basename) {
    throw new UnimplementedError();
  }

  @override
  File childFile(String basename) {
    throw new UnimplementedError();
  }

  @override
  Link childLink(String basename) {
    throw new UnimplementedError();
  }

  @override
  Future<Directory> create({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError(
          'Recursive create is not supported by Node API');
    var completer = new Completer();
    void callback(err) {
      if (err == null) {
        completer.complete(new _Directory(path));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);

    nodeFS.mkdir(path, jsCallback);
    return completer.future;
  }

  @override
  void createSync({bool recursive: false}) {
    if (recursive)
      throw new UnsupportedError(
          'Recursive create is not supported by Node API');
    nodeFS.mkdirSync(path);
  }

  @override
  Future<Directory> createTemp([String prefix]) {
    throw new UnimplementedError();
  }

  @override
  Directory createTempSync([String prefix]) {
    throw new UnimplementedError();
  }

  @override
  List<FileSystemEntity> listSync(
      {bool recursive: false, bool followLinks: true}) {
    return null; // fs.readdirSync(path).toList();
  }
}
