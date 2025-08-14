// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

/// The [`fs.constants` object] which contains various bit flags for use with
/// Node.js filesystem APIs.
///
/// [`fs.constants` object]: https://nodejs.org/docs/latest/api/fs.html#fsconstants
extension type FSConstants._(JSObject _) implements JSObject {
  /// The Node.js [`F_OK` constant].
  ///
  /// [`F_OK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-access-constants
  @JS('F_OK')
  external int get accessIsVisible;

  /// The Node.js [`R_OK` constant].
  ///
  /// [`R_OK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-access-constants
  @JS('R_OK')
  external int get accessIsReadable;

  /// The Node.js [`W_OK` constant].
  ///
  /// [`W_OK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-access-constants
  @JS('W_OK')
  external int get accessIsWritable;

  /// The Node.js [`X_OK` constant].
  ///
  /// [`X_OK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-access-constants
  @JS('X_OK')
  external int get accessIsExecutable;

  /// The Node.js [`COPYFILE_EXCL` constant].
  ///
  /// [`COPYFILE_EXCL` constant]: https://nodejs.org/docs/latest/api/fs.html#file-copy-constants
  @JS('COPYFILE_EXCL')
  external int get copyFileExclusive;

  /// The Node.js [`COPYFILE_FICLONE` constant].
  ///
  /// [`COPYFILE_FICLONE` constant]: https://nodejs.org/docs/latest/api/fs.html#file-copy-constants
  @JS('COPYFILE_FICLONE')
  external int get copyFileOnWrite;

  /// The Node.js [`COPYFILE_FICLONE_FORCE` constant].
  ///
  /// [`COPYFILE_FICLONE_FORCE` constant]: https://nodejs.org/docs/latest/api/fs.html#file-copy-constants
  @JS('COPYFILE_FICLONE')
  external int get copyFileOnWriteForce;

  /// The Node.js [`O_RDONLY` constant].
  ///
  /// [`O_RDONLY` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_RDONLY')
  external int get openReadOnly;

  /// The Node.js [`O_WRONLY` constant].
  ///
  /// [`O_WRONLY` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_WRONLY')
  external int get openWriteOnly;

  /// The Node.js [`O_RDWR` constant].
  ///
  /// [`O_WRONLY` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_RDWR')
  external int get openReadWrite;

  /// The Node.js [`O_CREAT` constant].
  ///
  /// [`O_CREAT` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_CREAT')
  external int get openCreate;

  /// The Node.js [`O_EXCL` constant].
  ///
  /// [`O_EXCL` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_EXCL')
  external int get openExclusive;

  /// The Node.js [`O_NOCTTY` constant].
  ///
  /// [`O_NOCTTY` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_NOCTTY')
  external int get openNoControllingTerminal;

  /// The Node.js [`O_TRUNC` constant].
  ///
  /// [`O_TRUNC` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_TRUNC')
  external int get openTruncate;

  /// The Node.js [`O_APPEND` constant].
  ///
  /// [`O_APPEND` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_APPEND')
  external int get openAppend;

  /// The Node.js [`O_DIRECTORY` constant].
  ///
  /// [`O_DIRECTORY` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_DIRECTORY')
  external int get openDir;

  /// The Node.js [`O_NOATIME` constant].
  ///
  /// [`O_NOATIME` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_NOATIME')
  external int get openNoAccessTime;

  /// The Node.js [`O_NOFOLLOW` constant].
  ///
  /// [`O_NOFOLLOW` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_NOFOLLOW')
  external int get openNoFollow;

  /// The Node.js [`O_SYNC` constant].
  ///
  /// [`O_SYNC` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_SYNC')
  external int get openSyncFile;

  /// The Node.js [`O_DSYNC` constant].
  ///
  /// [`O_DSYNC` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_DSYNC')
  external int get openSyncData;

  /// The Node.js [`O_SYMLINK` constant].
  ///
  /// [`O_SYMLINK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_SYMLINK')
  external int get openSymlink;

  /// The Node.js [`O_DIRECT` constant].
  ///
  /// [`O_DIRECT` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_DIRECT')
  external int get openDirect;

  /// The Node.js [`O_NONBLOCK` constant].
  ///
  /// [`O_NONBLOCK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('O_NONBLOCK')
  external int get openNonBlocking;

  /// The Node.js [`UV_FS_O_FILEMAP` constant].
  ///
  /// [`UV_FS_O_FILEMAP` constant]: https://nodejs.org/docs/latest/api/fs.html#file-open-constants
  @JS('UV_FS_O_FILEMAP')
  external int get openFileMap;

  /// The Node.js [`S_IFMT` constant].
  ///
  /// [`S_IFMT` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFMT')
  external int get statsTypeMask;

  /// The Node.js [`S_IFREG` constant].
  ///
  /// [`S_IFREG` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFREG')
  external int get statsTypeRegular;

  /// The Node.js [`S_IFDIR` constant].
  ///
  /// [`S_IFDIR` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFDIR')
  external int get statsTypeDir;

  /// The Node.js [`S_IFCHR` constant].
  ///
  /// [`S_IFCHR` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFCHR')
  external int get statsTypeCharacter;

  /// The Node.js [`S_IFBLK` constant].
  ///
  /// [`S_IFBLK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFBLK')
  external int get statsTypeBlock;

  /// The Node.js [`S_IFIFO` constant].
  ///
  /// [`S_IFIFO` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFIFO')
  external int get statsTypeFifo;

  /// The Node.js [`S_IFLNK` constant].
  ///
  /// [`S_IFLNK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFLNK')
  external int get statsTypeLink;

  /// The Node.js [`S_IFSOCK` constant].
  ///
  /// [`S_IFSOCK` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IFSOCK')
  external int get statsTypeSocket;

  /// The Node.js [`S_IRWXU` constant].
  ///
  /// [`S_IRWXU` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IRWXU')
  external int get statsModeOwnerAll;

  /// The Node.js [`S_IRUSR` constant].
  ///
  /// [`S_IRUSR` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IRUSR')
  external int get statsModeOwnerReadable;

  /// The Node.js [`S_IWUSR` constant].
  ///
  /// [`S_IWUSR` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IWUSR')
  external int get statsModeOwnerWritable;

  /// The Node.js [`S_IXUSR` constant].
  ///
  /// [`S_IXUSR` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IXUSR')
  external int get statsModeOwnerExecutable;

  /// The Node.js [`S_IRWXG` constant].
  ///
  /// [`S_IRWXG` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IRWXG')
  external int get statsModeGroupAll;

  /// The Node.js [`S_IRGRP` constant].
  ///
  /// [`S_IRGRP` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IRGRP')
  external int get statsModeGroupReadable;

  /// The Node.js [`S_IWGRP` constant].
  ///
  /// [`S_IWGRP` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IWGRP')
  external int get statsModeGroupWritable;

  /// The Node.js [`S_IXGRP` constant].
  ///
  /// [`S_IXGRP` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IXGRP')
  external int get statsModeGroupExecutable;

  /// The Node.js [`S_IRWXO` constant].
  ///
  /// [`S_IRWXO` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IRWXO')
  external int get statsModeOtherAll;

  /// The Node.js [`S_IROTH` constant].
  ///
  /// [`S_IROTH` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IROTH')
  external int get statsModeOtherReadable;

  /// The Node.js [`S_IWOTH` constant].
  ///
  /// [`S_IWOTH` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IWOTH')
  external int get statsModeOtherWritable;

  /// The Node.js [`S_IXOTH` constant].
  ///
  /// [`S_IXOTH` constant]: https://nodejs.org/docs/latest/api/fs.html#file-type-constants
  @JS('S_IXOTH')
  external int get statsModeOtherExecutable;
}
