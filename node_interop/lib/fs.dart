// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "fs" module bindings.
///
/// Use library-level [fs] object to access functionality of this module.
@JS()
library node_interop.fs;

import 'package:js/js.dart';

import 'events.dart';
import 'node.dart';
import 'stream.dart';

FS get fs => _fs ??= require('fs');
FS _fs;

@JS()
@anonymous
abstract class FS {
  external FSConstants get constants;
  external void access(path, [modeOrCallback, callback]);
  external void accessSync(path, [int mode]);
  external void appendFile(file, data, [options, callback]);
  external void appendFileSync(file, data, [options]);
  external void chmod(path, int mode, callback(error));
  external void chmodSync(path, int mode);
  external void chown(path, int uid, gid, callback(error));
  external void chownSync(path, int uid, gid);
  external void close(int fd, void callback(error));
  external void closeSync(int fd);
  external void copyFile(src, dest, num flags, void callback(error));
  external void copyFileSync(src, dest, num flags);
  external ReadStream createReadStream(path, [ReadStreamOptions options]);
  external WriteStream createWriteStream(path, [WriteStreamOptions options]);
  @deprecated
  external void exists(path, callback(bool exists));
  external bool existsSync(path);
  external void fchmod(int fd, int mode, callback(error));
  external void fchmodSync(int fd, int mode);
  external void fchown(int fd, int uid, gid, callback(error));
  external void fchownSync(int fd, int uid, gid);
  external void fdatasync(int fd, callback(error));
  external void fdatasyncSync(int fd);
  external void fstat(int fd, void callback(error, Stats stats));
  external Stats fstatSync(int fd);
  external void fsync(int fd, void callback(error));
  external void fsyncSync(int fd);
  external void ftruncate(int fd, [lenOrCallback, callback]);
  external void ftruncateSync(int fd, [len]);
  external void futimes(int fd, atime, mtime, callback(error));
  external void futimesSync(int fd, atime, mtime);
  external void lchmod(path, int mode, callback(error));
  external void lchmodSync(path, int mode);
  external void lchown(path, int uid, gid, callback(error));
  external void lchownSync(path, int uid, gid);
  external void link(existingPath, newPath, callback(error));
  external void linkSync(existingPath, newPath);
  external void lstat(path, void callback(error, Stats stats));
  external Stats lstatSync(path);
  external void mkdir(path, [modeOrCallback, void callback(error)]);
  external void mkdirSync(path, [int mode]);
  external void mkdtemp(String prefix,
      [optionsOrCallback, void callback(error, String folder)]);
  external String mkdtempSync(prefix, [options]);
  external void open(path, flags, [modeOrCallback, void callback(err, int fd)]);
  external int openSync(path, flags, [int mode]);
  external read(int fd, buffer, int offset, int length, int position,
      callback(error, int bytesRead, Buffer buffer));
  external void readdir(path,
      [optionsOrCallback, void callback(err, List files)]);
  external List readdirSync(path, [options]);
  external void readFile(path, [optionsOrCallback, callback(error, data)]);
  external dynamic readFileSync(path, [options]);
  external void readlink(path,
      [optionsOrCallback, callback(error, linkString)]);
  external dynamic readlinkSync(path, [options]);
  external int readSync(int fd, buffer, int offset, int length, int position);
  external void realpath(path,
      [optionsOrCallback, void callback(error, resolvedPath)]);
  // TODO: realpath.native(path[, options], callback)
  external String realpathSync(path, [options]);
  // TODO: realpathSync.native(path[, options])
  external void rename(oldPath, newPath, void callback(error));
  external void renameSync(oldPath, newPath);
  external void rmdir(path, void callback(error));
  external void rmdirSync(path);
  external void stat(path, void callback(error, Stats stats));
  external Stats statSync(path);
  external void symlink(target, path, [typeOrCallback, void callback(error)]);
  external void symlinkSync(target, path, [type]);

  external void truncate(path, [lenOrCallback, callback]);
  external void truncateSync(path, [int len]);

  external void unlink(path, [void callback(error)]);
  external void unlinkSync(path);

  external void unwatchFile(filename, [Function listener]);
  external void utimes(path, atime, mtime, callback(error));
  external void utimesSync(path, atime, mtime);

  external void watch(filename,
      [options, void listener(String eventType, filename)]);

  external void watchFile(filename,
      [optionsOrListener, void listener(Stats current, Stats previous)]);

  /// See official documentation on all possible argument combinations:
  /// - https://nodejs.org/api/fs.html#fs_fs_write_fd_buffer_offset_length_position_callback
  external void write(int fd, data, [arg1, arg2, arg3, Function callback]);

  external void writeFile(file, data,
      [optionsOrCallback, void callback(error)]);
  external void writeFileSync(file, data, [options]);

  /// See official documentation on all possible argument combinations:
  /// - https://nodejs.org/api/fs.html#fs_fs_writesync_fd_buffer_offset_length_position
  external int writeSync(int fd, data, [arg1, arg2, arg3]);
}

@JS()
@anonymous
abstract class FSConstants {
  /// File Access Constants for use with [FS.access].
  external int get F_OK;
  external int get R_OK;
  external int get W_OK;
  external int get X_OK;

  /// File Open Constants for use with [FS.open].
  external int get O_RDONLY;
  external int get O_WRONLY;
  external int get O_RDWR;
  external int get O_CREAT;
  external int get O_EXCL;
  external int get O_NOCTTY;
  external int get O_TRUNC;
  external int get O_APPEND;
  external int get O_DIRECTORY;
  external int get O_NOATIME;
  external int get O_NOFOLLOW;
  external int get O_SYNC;
  external int get O_DSYNC;
  external int get O_SYMLINK;
  external int get O_DIRECT;
  external int get O_NONBLOCK;

  /// File Type Constants for use with [Stats.mode].
  external int get S_IFMT;
  external int get S_IFREG;
  external int get S_IFDIR;
  external int get S_IFCHR;
  external int get S_IFBLK;
  external int get S_IFIFO;
  external int get S_IFLNK;
  external int get S_IFSOCK;

  /// File Mode Constants for use with [Stats.mode].
  external int get S_IRWXU;
  external int get S_IRUSR;
  external int get S_IWUSR;
  external int get S_IXUSR;
  external int get S_IRWXG;
  external int get S_IRGRP;
  external int get S_IWGRP;
  external int get S_IXGRP;
  external int get S_IRWXO;
  external int get S_IROTH;
  external int get S_IWOTH;
  external int get S_IXOTH;
}

@JS()
@anonymous
abstract class FSWatcher implements EventEmitter {
  external void close();
}

@JS()
@anonymous
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
  external bool isBlockDevice();
  external bool isCharacterDevice();
  external bool isDirectory();
  external bool isFIFO();
  external bool isFile();
  external bool isSocket();
  external bool isSymbolicLink();

  external num get dev;
  external num get ino;
  external num get mode;
  external num get nlink;
  external num get uid;
  external num get gid;
  external num get rdev;
  external num get blksize;
  external num get blocks;
  external num get atimeMs; // since 8.1.0
  external num get ctimeMs; // since 8.1.0
  external num get mtimeMs; // since 8.1.0
  external num get birthtimeMs; // since 8.1.0
  external Date get atime;
  external Date get ctime;
  external Date get mtime;
  external Date get birthtime;
  external int get size;
}
