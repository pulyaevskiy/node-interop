// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart';

import '../buffer/buffer.dart';
import 'big_int_file_system_stats.dart';
import 'big_int_stats.dart';
import 'dir.dart';
import 'dir_entry.dart';
import 'file_handle.dart';
import 'file_system_stats.dart';
import 'module.dart';
import 'stats.dart';

/// The `fs.promises` module which contains the promise- rather than
/// callback-oriented APIs.
///
/// We forward these through the main [FSModule] because they're much more
/// usable from a Dart context than the callbacks.
@anonymous
@internal
extension type FSPromises._(JSObject _) implements JSObject {
  external JSPromise<Null> access(NodePath path, [int? mode]);

  JSPromise<Null> appendFile(NodePath path, JSAny data,
      {String? encoding, int? mode, JSAny? flag, bool? flush}) {
    var options = AppendFileOptions();
    if (encoding != null) options.encoding = encoding;
    if (mode != null) options.mode = mode;
    if (flag != null) options.flag = flag;
    if (flush != null) options.flush = flush;
    return _appendFile(path, data, options);
  }

  @JS('appendFile')
  external JSPromise<Null> _appendFile(NodePath path, JSAny data,
      [AppendFileOptions? options]);

  @JS('chmod')
  external JSPromise<Null> changeMode(NodePath path, JSAny mode);

  @JS('chown')
  external JSPromise<Null> changeOwner(NodePath path, int uid, int gid);

  external JSPromise<Null> copyFile(NodePath src, NodePath dest, [int? mode]);

  JSPromise<Null> copyRecursive(NodePath src, NodePath dest,
      {bool? dereference,
      bool? errorOnExist,
      JSAny Function(String src, String dest)? filter,
      bool? force,
      int? mode,
      bool? preserveTimestamps,
      bool? verbatimSymlinks}) {
    var options = CopyRecursiveOptions();
    if (dereference != null) options.dereference = dereference;
    if (errorOnExist != null) options.errorOnExist = errorOnExist;
    if (filter != null) options.filter = filter.toJS;
    if (force != null) options.force = force;
    if (preserveTimestamps != null) {
      options.preserveTimestamps = preserveTimestamps;
    }
    if (verbatimSymlinks != null) options.verbatimSymlinks = verbatimSymlinks;
    return _copyRecursive(src, dest, options);
  }

  @JS('cp')
  external JSPromise<Null> _copyRecursive(
      NodePath src, NodePath dest, CopyRecursiveOptions options);

  JSAsyncIterator<JSString> glob(JSAny pattern,
      {JSAny? cwd,
      bool Function(String path)? exclude,
      List<String>? excludePatterns}) {
    var options = GlobOptions();
    if (cwd != null) options.cwd = cwd;
    if (exclude != null) {
      if (excludePatterns != null) {
        throw ArgumentError(
            'The exlude argument and excludePatterns argument may not both be '
            'passed at once');
      }
      options.exclude = exclude.toJS;
    } else if (excludePatterns != null) {
      options.exclude = excludePatterns.toJS;
    }
    return _glob(pattern, options) as JSAsyncIterator<JSString>;
  }

  JSAsyncIterator<FSDirEntry> globWithFileTypes(JSAny pattern,
      {JSAny? cwd,
      bool Function(String path)? exclude,
      List<String>? excludePatterns}) {
    var options = GlobOptions(withFileTypes: true);
    if (cwd != null) options.cwd = cwd;
    if (exclude != null) {
      if (excludePatterns != null) {
        throw ArgumentError(
            'The exlude argument and excludePatterns argument may not both be '
            'passed at once');
      }
      options.exclude = exclude.toJS;
    } else if (excludePatterns != null) {
      options.exclude = excludePatterns.toJS;
    }
    return _glob(pattern, options) as JSAsyncIterator<FSDirEntry>;
  }

  @JS('glob')
  external JSAsyncIterator<JSAny> _glob(JSAny pattern, GlobOptions options);

  @JS('lchown')
  external JSPromise<Null> changeLinkOwner(NodePath path, int uid, int gid);

  @JS('lutimes')
  external JSPromise<Null> updateLinkTimes(
      NodePath path, JSAny atime, JSAny mtime);

  external JSPromise<Null> link(NodePath existingPath, NodePath newPath);

  @JS('lstat')
  external JSPromise<FSStats> statLink(NodePath path);

  JSPromise<FSBigIntStats> statLinkBigInt(NodePath path) =>
      _statLink(path, StatOptions(bigint: true));

  @JS('lstat')
  external JSPromise<FSBigIntStats> _statLink(NodePath path,
      [StatOptions? options]);

  JSPromise<Null> makeDir(NodePath path, {JSAny? mode}) => (mode == null
      ? _makeDir(path)
      : _makeDir(path, MakeDirOptions(mode: mode))) as JSPromise<Null>;

  JSPromise<JSString> makeDirRecursive(NodePath path, {JSAny? mode}) {
    var options = MakeDirOptions(recursive: true);
    if (mode != null) options.mode = mode;
    return _makeDir(path, options) as JSPromise<JSString>;
  }

  @JS('mkdir')
  external JSPromise<JSString?> _makeDir(NodePath path,
      [MakeDirOptions? options]);

  JSPromise<JSString> makeTempDirectory(NodePath prefix, {String? encoding}) =>
      encoding == null
          ? _makeTempDirectory(prefix)
          : _makeTempDirectory(prefix, encoding);

  @JS('mkdtemp')
  external JSPromise<JSString> _makeTempDirectory(NodePath prefix,
      [String? encoding]);

  external JSPromise<FSFileHandle> open(NodePath path, JSAny flags,
      [JSAny? mode]);

  JSPromise<FSDir> openDir(NodePath path,
      {String? encoding, int? bufferSize, bool? recursive}) {
    var options = OpenDirOptions();
    if (encoding != null) options.encoding = encoding;
    if (bufferSize != null) options.bufferSize = bufferSize;
    if (recursive != null) options.recursive = recursive;
    return _openDir(path, options);
  }

  @JS('opendir')
  external JSPromise<FSDir> _openDir(NodePath path, OpenDirOptions options);

  JSPromise<JSArray<JSString>> readDir(NodePath path,
      {String? encoding, bool? recursive}) {
    var options = ReadDirOptions();
    if (encoding != null) options.encoding = encoding;
    if (recursive != null) options.recursive = recursive;
    return _readDir(path, options) as JSPromise<JSArray<JSString>>;
  }

  JSPromise<JSArray<FSDirEntry>> readDirWithFileTypes(NodePath path,
      {String? encoding, bool? recursive}) {
    var options = ReadDirOptions(withFileTypes: true);
    if (encoding != null) options.encoding = encoding;
    if (recursive != null) options.recursive = recursive;
    return _readDir(path, options) as JSPromise<JSArray<FSDirEntry>>;
  }

  @JS('readdir')
  external JSPromise<JSArray<JSAny>> _readDir(
      NodePath path, ReadDirOptions options);

  JSPromise<Buffer> readFile(NodePath path,
      {JSAny? flag, AbortSignal? signal}) {
    var options = ReadFileOptions();
    if (flag != null) options.flag = flag;
    if (signal != null) options.signal = signal;
    return _readFile(path, options) as JSPromise<Buffer>;
  }

  JSPromise<JSString> readFileAsString(NodePath path, String encoding,
      {JSAny? flag, AbortSignal? signal}) {
    var options = ReadFileOptions(encoding: encoding);
    if (flag != null) options.flag = flag;
    if (signal != null) options.signal = signal;
    return _readFile(path, options) as JSPromise<JSString>;
  }

  @JS('readFile')
  external JSPromise<JSAny> _readFile(NodePath path, ReadFileOptions options);

  JSPromise<JSString> readLink(NodePath path, {String? encoding}) =>
      (encoding == null ? _readLink(path) : _readLink(path, encoding))
          as JSPromise<JSString>;

  JSPromise<Buffer> readLinkAsBuffer(NodePath path) =>
      _readLink(path, 'buffer') as JSPromise<Buffer>;

  @JS('readlink')
  external JSPromise<JSAny> _readLink(NodePath path, [String? encoding]);

  JSPromise<JSString> realPath(NodePath path, {String? encoding}) =>
      (encoding == null ? _realPath(path) : _realPath(path, encoding))
          as JSPromise<JSString>;

  JSPromise<Buffer> realPathAsBuffer(NodePath path, {String? encoding}) =>
      _realPath(path, 'buffer') as JSPromise<Buffer>;

  @JS('realpath')
  external JSPromise<JSAny> _realPath(NodePath path, [String? encoding]);

  external JSPromise<Null> rename(NodePath oldPath, NodePath newPath);

  JSPromise<Null> removeDir(NodePath path,
      {int? maxRetries, bool? recursive, int? retryDelay}) {
    var options = RemoveDirOptions();
    if (maxRetries != null) options.maxRetries = maxRetries;
    if (recursive != null) options.recursive = recursive;
    if (retryDelay != null) options.retryDelay = retryDelay;
    return _removeDir(path, options);
  }

  @JS('rmdir')
  external JSPromise<Null> _removeDir(NodePath path,
      [RemoveDirOptions? options]);

  JSPromise<Null> remove(NodePath path,
      {bool? force, int? maxRetries, bool? recursive, int? retryDelay}) {
    var options = RemoveOptions();
    if (force != null) options.force = force;
    if (maxRetries != null) options.maxRetries = maxRetries;
    if (recursive != null) options.recursive = recursive;
    if (retryDelay != null) options.retryDelay = retryDelay;
    return _remove(path, options);
  }

  @JS('rm')
  external JSPromise<Null> _remove(NodePath path, [RemoveOptions? options]);

  external JSPromise<FSStats> stat(NodePath path);

  JSPromise<FSBigIntStats> statBigInt(NodePath path) =>
      _stat(path, StatOptions(bigint: true));

  @JS('stat')
  external JSPromise<FSBigIntStats> _stat(NodePath path,
      [StatOptions? options]);

  @JS('statfs')
  external JSPromise<FSFileSystemStats> statFileSystem(NodePath path);

  JSPromise<FSBigIntFileSystemStats> statFileSystemBigInt(NodePath path) =>
      _statFileSystem(path, StatOptions(bigint: true));

  @JS('statfs')
  external JSPromise<FSBigIntFileSystemStats> _statFileSystem(NodePath path,
      [StatOptions? options]);

  JSPromise<Null> symlink(NodePath target, NodePath path,
          [NodeSymlinkType? type]) =>
      type == null ? _symlink(target, path) : _symlink(target, path, type.name);

  @JS('symlink')
  external JSPromise<Null> _symlink(NodePath target, NodePath path,
      [String? type]);

  external JSPromise<Null> truncate(NodePath path, int length);

  external JSPromise<Null> unlink(NodePath path);

  @JS('utimes')
  external JSPromise<Null> updateTimes(NodePath path, JSAny atime, JSAny mtime);

  JSAsyncIterator<FSWatchEvent> watch(NodePath filename,
      {bool? persistent,
      bool? recursive,
      String? encoding,
      AbortSignal? signal}) {
    var options = WatchOptions();
    if (persistent != null) options.persistent = persistent;
    if (recursive != null) options.recursive = recursive;
    if (encoding != null) options.encoding = encoding;
    if (signal != null) options.signal = signal;
    return _watch(filename, options);
  }

  @JS('watch')
  external JSAsyncIterator<FSWatchEvent> _watch(NodePath filename,
      [WatchOptions? options]);

  JSPromise<Null> writeFile(NodePath filename, JSAny data,
      {String? encoding,
      int? mode,
      JSAny? flag,
      bool? flush,
      AbortSignal? signal}) {
    var options = WriteFileOptions();
    if (encoding != null) options.encoding = encoding;
    if (mode != null) options.mode = mode;
    if (flag != null) options.flag = flag;
    if (flush != null) options.flush = flush;
    if (signal != null) options.signal = signal;
    return _writeFile(filename, data, options);
  }

  @JS('writeFile')
  external JSPromise<Null> _writeFile(NodePath filename, JSAny data,
      [WriteFileOptions? options]);
}
