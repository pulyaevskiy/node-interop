// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart';

import '../buffer/buffer.dart';
import 'big_int_file_system_stats.dart';
import 'big_int_stats.dart';
import 'constants.dart';
import 'dir.dart';
import 'dir_entry.dart';
import 'file_handle.dart';
import 'file_system_stats.dart';
import 'promises.dart';
import 'stats.dart';

/// A purely documentary typedef used to indicate places where NodeJS APIs take
/// a path in the form of either a [JSString], a [JSUint8Array], or a [URL]
/// representing the filename.
///
/// In some asynchronous cases, a [FSFileHandle] is also valid; in similar
/// synchronous cases, a [JSNumber] representing a file descriptor is valid.
/// This is documented in the functions that support it.
typedef NodePath = JSAny;

// Normally this would be in lib/fs.dart, but we have to have it here to
// work around dart-lang/sdk#60772.
/// The Node.js [`fs` module].
///
/// [`fs` module]: https://nodejs.org/docs/latest/api/fs.html
///
/// Unlike the Node.js API, this exposes the modern promise-based APIs directly
/// on the `fs` module rather than on a separate `promises` object.
extension type FSModule._(JSObject _) implements JSObject {
  /// @nodoc
  @internal
  @JS('FileHandle')
  external JSFunction get fileHandleClass;

  /// @nodoc
  @internal
  @JS('Dir')
  external JSFunction get dirClass;

  /// @nodoc
  @internal
  @JS('Dirent')
  external JSFunction get dirEntryClass;

  /// @nodoc
  @internal
  @JS('ReadStream')
  external JSFunction get readStreamClass;

  /// @nodoc
  @internal
  @JS('WriteStream')
  external JSFunction get writeStreamClass;

  @JS('promises')
  external FSPromises get _promises;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsconstants
  external FSConstants get constants;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesaccesspath-mode
  JSPromise<Null> access(NodePath path, [int? mode]) =>
      _promises.access(path, mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsaccesssyncpath-mode
  external void accessSync(NodePath path, [int? mode]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesappendfilepath-data-options
  ///
  /// The [path] argument may also be a [FSFileHandle]. The [data] argument may
  /// be a [JSString] or a [JSUint8Array]. The [flag] argument may be either a
  /// [JSString] or a [JSNumber].
  JSPromise<Null> appendFile(NodePath path, JSAny data,
          {String? encoding, int? mode, JSAny? flag, bool? flush}) =>
      _promises.appendFile(path, data,
          encoding: encoding, mode: mode, flag: flag, flush: flush);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsappendfilesyncpath-data-options
  ///
  /// The [path] argument may also be a [FSFileHandle]. The [data] argument may
  /// be a [JSString] or a [JSUint8Array]. The [flag] argument may be either a
  /// [JSString] or a [JSNumber].
  void appendFileSync(NodePath path, JSAny data,
      {String? encoding, int? mode, JSAny? flag, bool? flush}) {
    var options = AppendFileOptions();
    if (encoding != null) options.encoding = encoding;
    if (mode != null) options.mode = mode;
    if (flag != null) options.flag = flag;
    if (flush != null) options.flush = flush;
    _appendFileSync(path, data, options);
  }

  @JS('appendFileSync')
  external void _appendFileSync(NodePath path, JSAny data,
      [AppendFileOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseschmodpath-mode
  ///
  /// The [mode] argument may be a [JSString] or a [JSNumber].
  JSPromise<Null> changeMode(NodePath path, JSAny mode) =>
      _promises.changeMode(path, mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fschmodsyncpath-mode
  ///
  /// The [mode] argument may be a [JSString] or a [JSNumber].
  @JS('chmodSync')
  external void changeModeSync(NodePath path, JSAny mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseschownpath-uid-gid
  JSPromise<Null> changeOwner(NodePath path, int uid, int gid) =>
      _promises.changeOwner(path, uid, gid);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fschownsyncpath-uid-gid
  @JS('chownSync')
  external void changeOwnerSync(NodePath path, int uid, int gid);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsclosesyncfd
  external void closeSync(int fd);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisescopyfilesrc-dest-mode
  JSPromise<Null> copyFile(NodePath src, NodePath dest, [int? mode]) =>
      mode == null
          ? _promises.copyFile(src, dest)
          : _promises.copyFile(src, dest, mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fscopyfilesyncsrc-dest-mode
  external void copyFileSync(NodePath src, NodePath dest, [int? mode]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisescpsrc-dest-options
  ///
  /// The [filter] function may return a [JSBoolean] or a [JSPromise<JSBoolean>].
  JSPromise<Null> copyRecursive(NodePath src, NodePath dest,
          {bool? dereference,
          bool? errorOnExist,
          JSAny Function(String src, String dest)? filter,
          bool? force,
          int? mode,
          bool? preserveTimestamps,
          bool? verbatimSymlinks}) =>
      _promises.copyRecursive(src, dest,
          dereference: dereference,
          errorOnExist: errorOnExist,
          filter: filter,
          force: force,
          mode: mode,
          preserveTimestamps: preserveTimestamps,
          verbatimSymlinks: verbatimSymlinks);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fscpsyncsrc-dest-options
  ///
  /// The [filter] function may return a [JSBoolean] or a [JSPromise<JSBoolean>].
  void copyRecursiveSync(NodePath src, NodePath dest,
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
    _copyRecursiveSync(src, dest, options);
  }

  @JS('cpSync')
  external void _copyRecursiveSync(
      NodePath src, NodePath dest, CopyRecursiveOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsexistssyncpath
  external bool existsSync(NodePath path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsfchmodsyncfd-mode
  ///
  /// The [mode] argument may be a [JSString] or a [JSNumber].
  @JS('fchmodSync')
  external bool changeFileModeSync(int fd, JSAny mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsfchownsyncfd-uid-gid
  @JS('fchmodSync')
  external bool changeFileOwnerSync(int fd, int uid, int gid);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsfdatasyncsyncfd
  @JS('fdatasyncSync')
  external void dataSyncFileSync(int fd);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsfstatsyncfd-options
  @JS('fstatSync')
  external void statFileSync(int fd);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#filehandlestatoptions
  FSBigIntStats statFileBigIntSync(int fd) =>
      _statFileSync(fd, StatOptions(bigint: true));

  @JS('fstatSync')
  external FSBigIntStats _statFileSync(int fd, [StatOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsfsyncsyncfd
  @JS('fsyncSync')
  external void syncFileSync(int fd);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsftruncatesyncfd-len
  @JS('ftruncateSync')
  external void truncateFileSync(int fd, [int? length]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsfutimessyncfd-atime-mtime
  ///
  /// The [atime] and [mtime] arguments can be [JSNumber]s, [JSString]s, or [JSDate]s.
  @JS('futimesSync')
  external void updateFileTimesSync(int fd, JSAny atime, JSAny mtime);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsglobsyncpattern-options
  ///
  /// The [pattern] argument can be a [JSString] or a `JSArray<JSString>`. The
  /// [cwd] argument can be a [JSString] or a [URL]. The [exclude] and
  /// [excludePatterns] options may not both be passed.
  JSArray<JSString> globSync(JSAny pattern,
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
    return _globSync(pattern, options) as JSArray<JSString>;
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsglobsyncpattern-options
  ///
  /// The [pattern] argument can be a [JSString] or a `JSArray<JSString>`. The
  /// [cwd] argument can be a [JSString] or a [URL]. The [exclude] and
  /// [excludePatterns] options may not both be passed.
  JSArray<FSDirEntry> globWithFileTypesSync(JSAny pattern,
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
    return _globSync(pattern, options) as JSArray<FSDirEntry>;
  }

  @JS('globSync')
  external JSArray<JSAny> _globSync(JSAny pattern, [GlobOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fslchownsyncpath-uid-gid
  @JS('lchownSync')
  external void changeLinkOwnerSync(NodePath path, int uid, int gid);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fslutimessyncpath-atime-mtime
  ///
  /// The [atime] and [mtime] arguments can be [JSNumber]s, [JSString]s, or [JSDate]s.
  @JS('lchownSync')
  external void updateLinkTimesSync(NodePath path, JSAny atime, JSAny mtime);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fslinksyncexistingpath-newpath
  external void linkSync(NodePath existingPath, NodePath newPath);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fslstatsyncpath-options
  @JS('lstatSync')
  external FSStats statLinkSync(NodePath path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fslstatsyncpath-options
  FSBigIntStats statLinkBigIntSync(NodePath path) =>
      _statLinkSync(path, StatOptions(bigint: true));

  @JS('lstatSync')
  external FSBigIntStats _statLinkSync(NodePath path, [StatOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsmkdirsyncpath-options
  ///
  /// The [mode] option may be a [JSString] or a [JSNumber].
  void makeDirSync(NodePath path, {JSAny? mode}) {
    if (mode == null) {
      _makeDirSync(path);
    } else {
      _makeDirSync(path, MakeDirOptions(mode: mode));
    }
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsmkdirsyncpath-options
  ///
  /// The [mode] option may be a [JSString] or a [JSNumber].
  String? makeDirRecursiveSync(NodePath path, {JSAny? mode}) {
    var options = MakeDirOptions(recursive: true);
    if (mode != null) options.mode = mode;
    return _makeDirSync(path, options);
  }

  @JS('mkdirSync')
  external String? _makeDirSync(NodePath path, [MakeDirOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsmkdtempsyncprefix-options
  String makeTempDirectorySync(NodePath prefix, {String? encoding}) =>
      encoding == null
          ? _makeTempDirectorySync(prefix)
          : _makeTempDirectorySync(prefix, encoding);

  @JS('mkdtempSync')
  external String _makeTempDirectorySync(NodePath prefix, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsopendirsyncpath-options
  FSDir openDirSync(NodePath path,
      {String? encoding, int? bufferSize, bool? recursive}) {
    var options = OpenDirOptions();
    if (encoding != null) options.encoding = encoding;
    if (bufferSize != null) options.bufferSize = bufferSize;
    if (recursive != null) options.recursive = recursive;
    return _openDirSync(path, options);
  }

  @JS('opendirSync')
  external FSDir _openDirSync(NodePath path, OpenDirOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsopensyncpath-flags-mode
  ///
  /// The [flags] argument and the [mode] argument may be either [JSString]s or
  /// [JSNumber]s.
  external FSFileHandle openSync(NodePath path, JSAny flags, [JSAny? mode]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreaddirsyncpath-options
  JSArray<JSString> readDirSync(NodePath path,
      {String? encoding, bool? recursive}) {
    var options = ReadDirOptions();
    if (encoding != null) options.encoding = encoding;
    if (recursive != null) options.recursive = recursive;
    return _readDirSync(path, options) as JSArray<JSString>;
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreaddirsyncpath-options
  JSArray<FSDirEntry> readDirWithFileTypesSync(NodePath path,
      {String? encoding, bool? recursive}) {
    var options = ReadDirOptions(withFileTypes: true);
    if (encoding != null) options.encoding = encoding;
    if (recursive != null) options.recursive = recursive;
    return _readDirSync(path, options) as JSArray<FSDirEntry>;
  }

  @JS('readdirSync')
  external JSArray<JSAny> _readDirSync(NodePath path, ReadDirOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreadfilesyncpath-options
  ///
  /// The [path] argument may also be a [FSFileHandle]. The [flag] argument may
  /// be either a [JSString] or a [JSNumber].
  Buffer readFileSync(NodePath path, {JSAny? flag}) {
    var options = ReadFileOptions();
    if (flag != null) options.flag = flag;
    return _readFileSync(path, options) as Buffer;
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreadfilesyncpath-options
  ///
  /// The [path] argument may also be a [JSNumber] representing a file
  /// descriptor. The [flag] argument may be either a [JSString] or a
  /// [JSNumber].
  String readFileAsStringSync(NodePath path, String encoding, {JSAny? flag}) {
    var options = ReadFileOptions(encoding: encoding);
    if (flag != null) options.flag = flag;
    return (_readFileSync(path, options) as JSString).toDart;
  }

  @JS('readFileSync')
  external JSAny _readFileSync(NodePath path, ReadFileOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreadlinksyncpath-options
  String readLinkSync(NodePath path, {String? encoding}) =>
      ((encoding == null ? _readLinkSync(path) : _readLinkSync(path, encoding))
              as JSString)
          .toDart;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreadlinksyncpath-options
  Buffer readLinkAsBufferSync(NodePath path) =>
      _readLinkSync(path, 'buffer') as Buffer;

  @JS('readlinkSync')
  external JSAny _readLinkSync(NodePath path, [String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreadsyncfd-buffer-options
  ///
  /// The [buffer] argument can be a [JSTypedArray] or a [JSDataView]. The
  /// [position] argument can be a [JSNumber] or a [JSBigInt].
  int readSync(int fd, JSObject buffer,
      {int? offset, int? length, JSAny? position}) {
    var options = ReadWriteOptions();
    if (offset != null) options.offset = offset;
    if (length != null) options.length = length;
    if (position != null) options.position = position;
    return _readSync(fd, buffer, options).bytesRead.toDartInt;
  }

  @JS('readSync')
  external ReadResult _readSync(
      int fd, JSObject buffer, ReadWriteOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsreadvsyncfd-buffers-position
  ///
  /// The [buffers] argument can contain [JSTypedArray]s or [JSDataView]s. The
  /// [position] argument can be a [JSNumber] or a [JSBigInt].
  int readToAll(int fd, JSArray<JSObject> buffers, {JSAny? position}) =>
      (position == null
              ? _readToAllSync(fd, buffers)
              : _readToAllSync(fd, buffers, position))
          .bytesRead
          .toDartInt;

  // The Node.js documentation only lists an integer as allowed for position,
  // but in practice a BigInt works as well (just like [read]).
  @JS('readvSync')
  external ReadResult _readToAllSync(int fd, JSArray<JSObject> buffers,
      [JSAny? position]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsrealpathsyncpath-options
  ///
  /// Following the Node.js promises API, this only exposes the native
  /// `realpath()` method, not Node.js's non-native implementation.
  String realPathSync(NodePath path, {String? encoding}) => ((encoding == null
          ? _realPathSync.native(path)
          : _realPathSync.native(path, encoding)) as JSString)
      .toDart;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsrealpathsyncpath-options
  ///
  /// Following the Node.js promises API, this only exposes the native
  /// `realpath()` method, not Node.js's non-native implementation.
  Buffer realPathAsBufferSync(NodePath path, {String? encoding}) =>
      _realPathSync.native(path, 'buffer') as Buffer;

  @JS('realpathSync')
  external _RealPathSyncNamespace get _realPathSync;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsrenamesyncoldpath-newpath
  external Null renameSync(NodePath oldPath, NodePath newPath);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsrmdirsyncpath-options
  void removeDirSync(NodePath path,
      {int? maxRetries, bool? recursive, int? retryDelay}) {
    var options = RemoveDirOptions();
    if (maxRetries != null) options.maxRetries = maxRetries;
    if (recursive != null) options.recursive = recursive;
    if (retryDelay != null) options.retryDelay = retryDelay;
    return _removeDirSync(path, options);
  }

  @JS('rmdirSync')
  external void _removeDirSync(NodePath path, [RemoveDirOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsrmsyncpath-options
  void removeSync(NodePath path,
      {bool? force, int? maxRetries, bool? recursive, int? retryDelay}) {
    var options = RemoveOptions();
    if (force != null) options.force = force;
    if (maxRetries != null) options.maxRetries = maxRetries;
    if (recursive != null) options.recursive = recursive;
    if (retryDelay != null) options.retryDelay = retryDelay;
    return _removeSync(path, options);
  }

  @JS('rmSync')
  external void _removeSync(NodePath path, [RemoveOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsstatsyncpath-options
  external FSStats statSync(NodePath path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsstatsyncpath-options
  FSBigIntStats statBigIntSync(NodePath path) =>
      _statSync(path, StatOptions(bigint: true));

  @JS('statSync')
  external FSBigIntStats _statSync(NodePath path, [StatOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsstatfssyncpath-options
  @JS('statfsSync')
  external FSFileSystemStats statFileSystemSync(NodePath path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsstatfssyncpath-options
  FSBigIntFileSystemStats statFileSystemBigIntSync(NodePath path) =>
      _statFileSystemSync(path, StatOptions(bigint: true));

  @JS('statfsSync')
  external FSBigIntFileSystemStats _statFileSystemSync(NodePath path,
      [StatOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fssymlinksynctarget-path-type
  void symlinkSync(NodePath target, NodePath path, [NodeSymlinkType? type]) {
    if (type == null) {
      _symlinkSync(target, path);
    } else {
      _symlinkSync(target, path, type.name);
    }
  }

  @JS('symlinkSync')
  external void _symlinkSync(NodePath target, NodePath path, [String? type]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fstruncatesyncpath-len
  external void truncateSync(NodePath path, int length);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsunlinksyncpath
  external void unlinkSync(NodePath path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fsutimessyncpath-atime-mtime
  @JS('utimesSync')
  external void updateTimesSync(NodePath path, JSAny atime, JSAny mtime);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fswritefilesyncfile-data-options
  ///
  /// The [filename] argument may also be a [JSNumber] representing a file
  /// descriptor. The [data] argument may be a [JSString], a [JSTypedArray], a
  /// [JSDataView], or an [JSAsyncIterable], [Iterable], or [NodeReadable] of
  /// any of those types. The [flag] argument may be either a [JSString] or a
  /// [JSNumber].
  void writeFileSync(NodePath filename, JSAny data,
      {String? encoding, int? mode, JSAny? flag, bool? flush}) {
    var options = WriteFileOptions();
    if (encoding != null) options.encoding = encoding;
    if (mode != null) options.mode = mode;
    if (flag != null) options.flag = flag;
    if (flush != null) options.flush = flush;
    return _writeFileSync(filename, data, options);
  }

  @JS('writeFileSync')
  external void _writeFileSync(NodePath filename, JSAny data,
      [WriteFileOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fswritefilesyncfile-data-options
  ///
  /// The [buffer] argument can be a [JSTypedArray] or a [JSDataView].
  int writeSync(int fd, JSObject buffer,
      {int? offset, int? length, int? position}) {
    var options = ReadWriteOptions();
    if (offset != null) options.offset = offset;
    if (length != null) options.length = length;
    if (position != null) options.position = position.toJS;
    return _writeSync(fd, buffer, options).bytesWritten.toDartInt;
  }

  @JS('writeSync')
  external WriteResult _writeSync(
      int fd, JSObject buffer, ReadWriteOptions options);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fswritesyncfd-string-position-encoding
  int writeStringSync(int fd, String string,
          {int? position, String? encoding}) =>
      _writeStringSync(fd, string, position, encoding ?? 'utf8')
          .bytesWritten
          .toDartInt;

  @JS('writeSync')
  external WriteResult _writeStringSync(int fd, String string,
      [int? position, String? encoding]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fswritevsyncfd-buffers-position
  ///
  /// The [buffers] argument can contain [JSTypedArray]s or [JSDataView]s.
  int writeFromAllSync(JSArray<JSObject> buffers, {int? position}) =>
      (position == null
              ? _writeFromAllSync(buffers)
              : _writeFromAllSync(buffers, position))
          .bytesWritten
          .toDartInt;

  @JS('writevSync')
  external WriteResult _writeFromAllSync(JSArray<JSObject> buffers,
      [int? position]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesglobpattern-options
  ///
  /// The [pattern] argument can be a [JSString] or a `JSArray<JSString>`. The
  /// [cwd] argument can be a [JSString] or a [URL]. The [exclude] and
  /// [excludePatterns] options may not both be passed.
  JSAsyncIterator<JSString> glob(JSAny pattern,
          {JSAny? cwd,
          bool Function(String path)? exclude,
          List<String>? excludePatterns}) =>
      _promises.glob(pattern,
          cwd: cwd, exclude: exclude, excludePatterns: excludePatterns);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesglobpattern-options
  ///
  /// The [pattern] argument can be a [JSString] or a `JSArray<JSString>`. The
  /// [cwd] argument can be a [JSString] or a [URL]. The [exclude] and
  /// [excludePatterns] options may not both be passed.
  JSAsyncIterator<FSDirEntry> globWithFileTypes(JSAny pattern,
          {JSAny? cwd,
          bool Function(String path)? exclude,
          List<String>? excludePatterns}) =>
      _promises.globWithFileTypes(pattern,
          cwd: cwd, exclude: exclude, excludePatterns: excludePatterns);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseslchownpath-uid-gid
  JSPromise<Null> changeLinkOwner(NodePath path, int uid, int gid) =>
      _promises.changeLinkOwner(path, uid, gid);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseslchownpath-uid-gid
  ///
  /// The [atime] and [mtime] arguments can be [JSNumber]s, [JSString]s, or [JSDate]s.
  JSPromise<Null> updateLinkTimes(NodePath path, JSAny atime, JSAny mtime) =>
      _promises.updateLinkTimes(path, atime, mtime);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseslinkexistingpath-newpath
  JSPromise<Null> link(NodePath existingPath, NodePath newPath) =>
      _promises.link(existingPath, newPath);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseslstatpath-options
  JSPromise<FSStats> statLink(NodePath path) => _promises.statLink(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseslstatpath-options
  JSPromise<FSBigIntStats> statLinkBigInt(NodePath path) =>
      _promises.statLinkBigInt(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesmkdirpath-options
  ///
  /// The [mode] option may be a [JSString] or a [JSNumber].
  JSPromise<Null> makeDir(NodePath path, {JSAny? mode}) =>
      _promises.makeDir(path, mode: mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesmkdirpath-options
  ///
  /// The [mode] option may be a [JSString] or a [JSNumber].
  JSPromise<JSString?> makeDirRecursive(NodePath path, {JSAny? mode}) =>
      _promises.makeDirRecursive(path, mode: mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesmkdtempprefix-options
  JSPromise<JSString> makeTempDirectory(NodePath prefix, {String? encoding}) =>
      _promises.makeTempDirectory(prefix, encoding: encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesopenpath-flags-mode
  ///
  /// The [flags] argument and the [mode] argument may be either [JSString]s or
  /// [JSNumber]s.
  JSPromise<FSFileHandle> open(NodePath path, JSAny flags, [JSAny? mode]) =>
      _promises.open(path, flags, mode);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesopendirpath-options
  JSPromise<FSDir> openDir(NodePath path,
          {String? encoding, int? bufferSize, bool? recursive}) =>
      _promises.openDir(path,
          encoding: encoding, bufferSize: bufferSize, recursive: recursive);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesreaddirpath-options
  JSPromise<JSArray<JSString>> readDir(NodePath path,
          {String? encoding, bool? recursive}) =>
      _promises.readDir(path, encoding: encoding, recursive: recursive);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesreaddirpath-options
  JSPromise<JSArray<FSDirEntry>> readDirWithFileTypes(NodePath path,
          {String? encoding, bool? recursive}) =>
      _promises.readDirWithFileTypes(path,
          encoding: encoding, recursive: recursive);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesreadfilepath-options
  ///
  /// The [path] argument may also be a [FSFileHandle]. The [flag] argument may
  /// be either a [JSString] or a [JSNumber].
  JSPromise<Buffer> readFile(NodePath path,
          {JSAny? flag, AbortSignal? signal}) =>
      _promises.readFile(path, flag: flag, signal: signal);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesreadfilepath-options
  ///
  /// The [path] argument may also be a [FSFileHandle]. The [flag] argument may
  /// be either a [JSString] or a [JSNumber].
  JSPromise<JSString> readFileAsString(NodePath path, String encoding,
          {JSAny? flag, AbortSignal? signal}) =>
      _promises.readFileAsString(path, encoding, flag: flag, signal: signal);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesreadlinkpath-options
  JSPromise<JSString> readLink(NodePath path, {String? encoding}) =>
      _promises.readLink(path, encoding: encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesreadlinkpath-options
  JSPromise<Buffer> readLinkAsBuffer(NodePath path) =>
      _promises.readLinkAsBuffer(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesrealpathpath-options
  JSPromise<JSString> realPath(NodePath path, {String? encoding}) =>
      _promises.realPath(path, encoding: encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesrealpathpath-options
  JSPromise<Buffer> realPathAsBuffer(NodePath path, {String? encoding}) =>
      _promises.realPathAsBuffer(path, encoding: encoding);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesrenameoldpath-newpath
  JSPromise<Null> rename(NodePath oldPath, NodePath newPath) =>
      _promises.rename(oldPath, newPath);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesrmdirpath-options
  JSPromise<Null> removeDir(NodePath path,
          {int? maxRetries, bool? recursive, int? retryDelay}) =>
      _promises.removeDir(path,
          maxRetries: maxRetries, recursive: recursive, retryDelay: retryDelay);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesrmpath-options
  JSPromise<Null> remove(NodePath path,
          {bool? force, int? maxRetries, bool? recursive, int? retryDelay}) =>
      _promises.remove(path,
          force: force,
          maxRetries: maxRetries,
          recursive: recursive,
          retryDelay: retryDelay);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesstatpath-options
  JSPromise<FSStats> stat(NodePath path) => _promises.stat(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesstatpath-options
  JSPromise<FSBigIntStats> statBigInt(NodePath path) =>
      _promises.statBigInt(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesstatpath-options
  JSPromise<FSFileSystemStats> statFileSystem(NodePath path) =>
      _promises.statFileSystem(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesstatpath-options
  JSPromise<FSBigIntFileSystemStats> statFileSystemBigInt(NodePath path) =>
      _promises.statFileSystemBigInt(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisessymlinktarget-path-type
  JSPromise<Null> symlink(NodePath target, NodePath path,
          [NodeSymlinkType? type]) =>
      _promises.symlink(target, path, type);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisestruncatepath-len
  JSPromise<Null> truncate(NodePath path, int length) =>
      _promises.truncate(path, length);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesunlinkpath
  JSPromise<Null> unlink(NodePath path) => _promises.unlink(path);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromisesutimespath-atime-mtime
  ///
  /// The [atime] and [mtime] arguments can be [JSNumber]s, [JSString]s, or [JSDate]s.
  JSPromise<Null> updateTimes(NodePath path, JSAny atime, JSAny mtime) =>
      _promises.updateTimes(path, atime, mtime);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseswatchfilename-options
  JSAsyncIterator<FSWatchEvent> watch(NodePath filename,
          {bool? persistent,
          bool? recursive,
          String? encoding,
          AbortSignal? signal}) =>
      _promises.watch(filename,
          persistent: persistent,
          recursive: recursive,
          encoding: encoding,
          signal: signal);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#fspromiseswritefilefile-data-options
  ///
  /// The [filename] argument may also be a [FSFileHandle]. The [data] argument may
  /// be a [JSString], a [JSTypedArray], a [JSDataView], or an
  /// [JSAsyncIterable], [Iterable], or [NodeReadable] of any of those types.
  /// The [flag] argument may be either a [JSString] or a [JSNumber].
  JSPromise<Null> writeFile(NodePath filename, JSAny data,
          {String? encoding,
          int? mode,
          JSAny? flag,
          bool? flush,
          AbortSignal? signal}) =>
      _promises.writeFile(filename, data,
          encoding: encoding,
          mode: mode,
          flag: flag,
          flush: flush,
          signal: signal);
}

/// Possible types of Windows symlink that can be created by [FSModule.symlink].
enum NodeSymlinkType { dir, file, junction }

/// Options for [FSModule.appendFile].
///
/// @nodoc
@internal
extension type AppendFileOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external int? mode;
  external JSAny? flag;
  external bool? flush;

  factory AppendFileOptions() => AppendFileOptions._(JSObject());
}

/// Options for [FSModule.cp].
///
/// @nodoc
@internal
extension type CopyRecursiveOptions._(JSObject _) implements JSObject {
  external bool? dereference;
  external bool? errorOnExist;
  external JSFunction? filter;
  external bool? force;
  external int? mode;
  external bool? preserveTimestamps;
  external bool? verbatimSymlinks;

  factory CopyRecursiveOptions() => CopyRecursiveOptions._(JSObject());
}

/// Options for [FSModule.glob].
///
/// @nodoc
@internal
extension type GlobOptions._(JSObject _) implements JSObject {
  external JSAny? cwd;
  external JSObject? exclude;
  external bool? withFileTypes;

  external GlobOptions({bool? withFileTypes});
}

/// Options for [FSModule.stat].
///
/// @nodoc
@internal
extension type StatOptions._(JSObject _) implements JSObject {
  external bool? bigint;

  external StatOptions({bool? bigint});
}

/// Options for [FSModule.mkdir].
///
/// @nodoc
@internal
extension type MakeDirOptions._(JSObject _) implements JSObject {
  external bool? recursive;
  external JSAny? mode;

  external MakeDirOptions({bool? recursive, JSAny? mode});
}

/// Options for [FSModule.openDir].
///
/// @nodoc
@internal
extension type OpenDirOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external int? bufferSize;
  external bool? recursive;

  external OpenDirOptions({bool? recursive, JSAny? mode});
}

/// Options for [FSModule.readDir].
///
/// @nodoc
@internal
extension type ReadDirOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external bool? withFileTypes;
  external bool? recursive;

  external ReadDirOptions({bool? withFileTypes});
}

/// Options for [FSModule.readFile].
///
/// @nodoc
@internal
extension type ReadFileOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external JSAny? flag;
  external AbortSignal? signal;

  external ReadFileOptions({String? encoding});
}

/// Options for [FSFileHandle.read] and [FSFileHandle.write].
///
/// @nodoc
@internal
extension type ReadWriteOptions._(JSObject _) implements JSObject {
  external int? offset;
  external int? length;
  external JSAny? position;

  factory ReadWriteOptions() => ReadWriteOptions._(JSObject());
}

/// The object returned by [FSFileHandle._read] and [FSFileHandle._readToAll].
///
/// @nodoc
@internal
extension type ReadResult._(JSObject _) implements JSObject {
  external JSNumber bytesRead;
}

/// The object that provides access to `fs.realpathSync.native()`.
extension type _RealPathSyncNamespace._(JSObject _) implements JSObject {
  external JSAny native(NodePath path, [String? encoding]);
}

/// Options for [FSModule.removeDir].
///
/// @nodoc
@internal
extension type RemoveDirOptions._(JSObject _) implements JSObject {
  external int? maxRetries;
  external bool? recursive;
  external int? retryDelay;

  factory RemoveDirOptions() => RemoveDirOptions._(JSObject());
}

/// Options for [FSModule.remove].
///
/// @nodoc
@internal
extension type RemoveOptions._(JSObject _) implements JSObject {
  external bool? force;
  external int? maxRetries;
  external bool? recursive;
  external int? retryDelay;

  factory RemoveOptions() => RemoveOptions._(JSObject());
}

/// Options for [FSModule.watch].
///
/// @nodoc
@internal
extension type WatchOptions._(JSObject _) implements JSObject {
  external bool? persistent;
  external bool? recursive;
  external String? encoding;
  external AbortSignal? signal;

  factory WatchOptions() => WatchOptions._(JSObject());
}

/// An event emitted by [FSModule.watch].
extension type FSWatchEvent._(JSObject _) implements JSObject {
  external String get eventType;
  external String? get filename;
}

/// Options for [FSModule.writeFile].
///
/// @nodoc
@internal
extension type WriteFileOptions._(JSObject _) implements JSObject {
  external String? encoding;
  external int? mode;
  external JSAny? flag;
  external bool? flush;
  external AbortSignal? signal;

  factory WriteFileOptions() => WriteFileOptions._(JSObject());
}

/// The object returned by [FSFileHandle._write].
///
/// @nodoc
@internal
extension type WriteResult._(JSObject _) implements JSObject {
  external JSNumber bytesWritten;
}
