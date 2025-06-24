// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

/// The Node.js [`fs.Stats` object], with integer values.
///
/// [`fs.Stats` object]: https://nodejs.org/docs/latest/api/fs.html#class-fsstats
@anonymous
extension type FSStats._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsisblockdevice
  bool get isBlockDevice => _isBlockDevice();

  @JS('isBlockDevice')
  external bool _isBlockDevice();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsischaracterdevice
  bool get isCharacterDevice => _isCharacterDevice();

  @JS('isCharacterDevice')
  external bool _isCharacterDevice();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsisdirectory
  bool get isDir => _isDir();

  @JS('isDirectory')
  external bool _isDir();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsisfifo
  bool get isFifo => _isFifo();

  @JS('isFIFO')
  external bool _isFifo();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsisfile
  bool get isFile => _isFile();

  @JS('isFile')
  external bool _isFile();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsissocket
  bool get isSocket => _isSocket();

  @JS('isSocket')
  external bool _isSocket();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsissymboliclink
  bool get isSymbolicLink => _isSymbolicLink();

  @JS('isSymbolicLink')
  external bool _isSymbolicLink();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsdev
  @JS('dev')
  external int get device;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsino
  @JS('ino')
  external int get inode;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsmode
  external int get mode;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsnlink
  @JS('nlink')
  external int get numberOfHardLinks;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsuid
  @JS('uid')
  external int get userID;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsgid
  @JS('gid')
  external int get groupID;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsrdev
  @JS('rdev')
  external int get deviceIdentifier;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statssize
  external int get size;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsblksize
  @JS('blksize')
  external int get blockSize;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsblocks
  external int get blocks;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsatimems
  @JS('atimeMs')
  external double get accessTimeInMilliseconds;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsmtimems
  @JS('mtimeMs')
  external double get modificationTimeInMilliseconds;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsctimems
  @JS('ctimeMs')
  external double get statusChangeTimeInMilliseconds;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsbirthtimems
  @JS('birthtimeMs')
  external double get birthTimeInMilliseconds;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsatime
  @JS('atime')
  external JSDate get accessTime;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsmtime
  @JS('mtime')
  external JSDate get modificationTime;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsctime
  @JS('ctime')
  external JSDate get statusChangeTime;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#statsbirthtime
  @JS('birthtime')
  external JSDate get birthTime;
}
