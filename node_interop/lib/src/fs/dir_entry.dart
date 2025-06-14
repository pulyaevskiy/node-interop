// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../../fs.dart';

/// The Node.js [`fs.Dirent`] type.
///
/// [`fs.Dirent`]: https://nodejs.org/docs/latest/api/fs.html#class-fsdirent
@anonymous
extension type FSDirEntry._(JSObject _) implements JSObject {
  /// Returns whether [value] is an instance of this type.
  static bool isA(JSAny? value) => value.instanceof(fs.dirEntryClass);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntisblockdevice
  bool get isBlockDevice => _isBlockDevice();

  @JS('isBlockDevice')
  external bool _isBlockDevice();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntischaracterdevice
  bool get isCharacterDevice => _isCharacterDevice();

  @JS('isCharacterDevice')
  external bool _isCharacterDevice();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntisdirectory
  bool get isDirectory => _isDirectory();

  @JS('isDirectory')
  external bool _isDirectory();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntisfifo
  bool get isFifo => _isFifo();

  @JS('isFIFO')
  external bool _isFifo();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntisfile
  bool get isFile => _isFile();

  @JS('isFile')
  external bool _isFile();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntissocket
  bool get isSocket => _isSocket();

  @JS('isSocket')
  external bool _isSocket();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntissymboliclink
  bool get isSymbolicLink => _isSymbolicLink();

  @JS('isSymbolicLink')
  external bool _isSymbolicLink();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntname
  external String get name;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/fs.html#direntparentpath
  external String get parentPath;
}
