// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:js' as js;

import 'package:node_interop/fs.dart';
import 'package:node_interop/node.dart';
import 'package:node_interop/os.dart';
import 'package:node_interop/path.dart' as node_path;
import 'package:path/path.dart';

import 'file.dart';
import 'file_system_entity.dart';
import 'link.dart';
import 'platform.dart';

/// A reference to a directory (or _folder_) on the file system.
///
/// A Directory instance is an object holding a [path] on which operations can
/// be performed. The path to the directory can be [absolute] or relative.
/// You can get the parent directory using the getter [parent],
/// a property inherited from [FileSystemEntity].
///
/// In addition to being used as an instance to access the file system,
/// Directory has a number of static properties, such as [systemTemp],
/// which gets the system's temporary directory, and the getter and setter
/// [current], which you can use to access or change the current directory.
///
/// Create a new Directory object with a pathname to access the specified
/// directory on the file system from your program.
///
///     var myDir = Directory('myDir');
///
/// Most methods in this class occur in synchronous and asynchronous pairs,
/// for example, [create] and [createSync].
/// Unless you have a specific reason for using the synchronous version
/// of a method, prefer the asynchronous version to avoid blocking your program.
///
/// ## Create a directory
///
/// The following code sample creates a directory using the [create] method.
/// By setting the `recursive` parameter to true, you can create the
/// named directory and all its necessary parent directories,
/// if they do not already exist.
///
///     import 'package:node_io/node_io.dart';
///
///     void main() {
///       // Creates dir/ and dir/subdir/.
///       Directory('dir/subdir').create(recursive: true)
///         // The created directory is returned as a Future.
///         .then((Directory directory) {
///           print(directory.path);
///       });
///     }
///
/// ## List a directory
///
/// Use the [list] or [listSync] methods to get the files and directories
/// contained by a directory.
/// Set `recursive` to true to recursively list all subdirectories.
/// Set `followLinks` to true to follow symbolic links.
/// The list method returns a [Stream] that provides FileSystemEntity
/// objects. Use the listen callback function to process each object
/// as it become available.
///
///     import 'package:node_io/node_io.dart';
///
///     void main() {
///       // Get the system temp directory.
///       var systemTempDir = Directory.systemTemp;
///
///       // List directory contents, recursing into sub-directories,
///       // but not following symbolic links.
///       systemTempDir.list(recursive: true, followLinks: false)
///         .listen((FileSystemEntity entity) {
///           print(entity.path);
///         });
///     }
class Directory extends FileSystemEntity implements io.Directory {
  @override
  final String path;

  Directory(this.path);

  /// Creates a directory object pointing to the current working
  /// directory.
  static io.Directory get current => Directory(process.cwd());

  /// Sets the current working directory of the Dart process including
  /// all running isolates. The new value set can be either a [Directory]
  /// or a [String].
  ///
  /// The new value is passed to the OS's system call unchanged, so a
  /// relative path passed as the new working directory will be
  /// resolved by the OS.
  static set current(path) {
    path = (path is io.Directory) ? path.path : path;
    assert(path is String);
    process.chdir(path);
  }

  /// Gets the system temp directory.
  ///
  /// Gets the directory provided by the operating system for creating
  /// temporary files and directories in.
  /// The location of the system temp directory is platform-dependent,
  /// and may be set by an environment variable.
  static io.Directory get systemTemp {
    return Directory(os.tmpdir());
  }

  @override
  io.Directory get absolute => Directory(node_path.path.resolve(path));

  @override
  Future<bool> exists() => FileStat.stat(path)
      .then((stat) => stat.type == io.FileSystemEntityType.directory);

  @override
  bool existsSync() =>
      FileStat.statSync(path).type == io.FileSystemEntityType.directory;

  @override
  Future<io.FileSystemEntity> delete({bool recursive = false}) {
    if (recursive) {
      return Future.error(
          UnsupportedError('Recursive delete is not supported by Node API'));
    }
    final completer = Completer<Directory>();

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
  void deleteSync({bool recursive = false}) {
    if (recursive) {
      throw UnsupportedError('Recursive delete is not supported in Node.');
    }
    fs.rmdirSync(path);
  }

  @override
  Stream<FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {
    if (recursive) {
      throw UnsupportedError('Recursive list is not supported in Node.');
    }
    final controller = StreamController<FileSystemEntity>();

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
            controller.add(File(filePath));
          } else if (stat.type == io.FileSystemEntityType.directory) {
            controller.add(Directory(filePath));
          } else {
            controller.add(Link(filePath));
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
    final completer = Completer<Directory>();
    void callback(err) {
      if (err == null) {
        completer.complete(Directory(newPath));
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
    return Directory(newPath);
  }

  @override
  Future<Directory> create({bool recursive = false}) {
    if (recursive) {
      throw UnsupportedError('Recursive create is not supported in Node.');
    }
    final completer = Completer<Directory>();
    void callback(err) {
      if (err == null) {
        completer.complete(Directory(path));
      } else {
        completer.completeError(err);
      }
    }

    var jsCallback = js.allowInterop(callback);

    fs.mkdir(path, jsCallback);
    return completer.future;
  }

  @override
  void createSync({bool recursive = false}) {
    if (recursive) {
      throw UnsupportedError('Recursive create is not supported in Node.');
    }
    fs.mkdirSync(path);
  }

  @override
  Future<io.Directory> createTemp([String prefix]) {
    prefix ??= '';
    if (path == '') {
      throw ArgumentError('Directory.createTemp called with an empty path. '
          'To use the system temp directory, use Directory.systemTemp');
    }
    String fullPrefix;
    if (path.endsWith('/') || (Platform.isWindows && path.endsWith('\\'))) {
      fullPrefix = '$path$prefix';
    } else {
      fullPrefix = '$path${Platform.pathSeparator}$prefix';
    }

    final completer = Completer<Directory>();
    void callback(err, result) {
      if (err == null) {
        completer.complete(Directory(result));
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
      throw ArgumentError('Directory.createTemp called with an empty path. '
          'To use the system temp directory, use Directory.systemTemp');
    }
    String fullPrefix;
    if (path.endsWith('/') || (Platform.isWindows && path.endsWith('\\'))) {
      fullPrefix = '$path$prefix';
    } else {
      fullPrefix = '$path${Platform.pathSeparator}$prefix';
    }
    final resultPath = fs.mkdtempSync(fullPrefix);
    return Directory(resultPath);
  }

  @override
  List<io.FileSystemEntity> listSync(
      {bool recursive = false, bool followLinks = true}) {
    if (recursive) {
      throw UnsupportedError('Recursive list is not supported in Node.js.');
    }

    final files = fs.readdirSync(path);
    return files.map((filePath) {
      // Need to append the original path to build a proper path
      filePath = join(path, filePath);
      final stat = FileStat.statSync(filePath);
      if (stat.type == io.FileSystemEntityType.file) {
        return File(filePath);
      } else if (stat.type == io.FileSystemEntityType.directory) {
        return Directory(filePath);
      } else {
        return Link(filePath);
      }
    }).toList();
  }

  @override
  String toString() {
    return "Directory: '$path'";
  }
}
