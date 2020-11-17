## 1.2.0

- Added a `nodeFileSystem` top-level field that implements the `file` package's
  `FileSystem` API.
- Added `file` package members to instance types, including
  `FileSystemEntity.fileSystem`, `.basename`, and `.dirname` as well as
  `Directory.childDirectory()`, `.childFile()`, and `.childLink()`.

## 1.1.1

- Implemented `stdout` and `stderr` library-level properties.
- `Platform.isIOS` and `Platform.isFuchsia` now throw `UnsupportedError`.

## 1.1.0

- Added support for Dart 2.8 (#75)
- Bumped Dart SDK constraint to 2.2.0

## 1.0.1+2

- More preparation for Uint8List SDK breaking change (dart-lang/sdk#36900).
  See #61 and #63 for details.

## 1.0.1+1

- Prepare for Uint8List SDK breaking change (dart-lang/sdk#36900).
  See #59 and #60 for details.

## 1.0.1

- Server side `NodeHttpRequest` and `NodeHttpResponse` are now available in public interface.

## 1.0.0

First stable release of this library which implements subset of `dart:io` interfaces,
including File System objects, HttpServer, Platform and other common classes.

Not all `dart:io` interfaces are covered yet. Feel free to file an issue on Github if you need
a specific class implemented in node_io.

- Complete file system implementations for `Directory`, `File`, `RandomAccessFile`, `Link`.
- Added `STATUS.md` which reflects coverage of already implemented or exported `dart:io` APIs.

## 1.0.0-dev.10.0

- Fixed `NodeHttpResponse.redirect` failing to convert `Uri` to string.

## 1.0.0-dev.9.0

- Upgraded to latest build_node_compilers (0.2.0)

## 1.0.0-dev.8.0

- Fixed: analysis warnings with latest Pub and Dart SDK.

## 1.0.0-dev.7.0

- Fixed: handling errors in `Directory.delete`.
- Fixed: handling relative paths in `Directory.list`.
- Fixed: strong mode issues in `Directory` and `File`.
- Added: `File.create`, `File.delete`, `File.readAsString`, `File.rename`,
    `File.writeAsBytes`, `File.writeAsString`.
- Fixed: handling errors in `File.open`, `File.stat`, `File.statSync`.
- Fixed: converting byte data in `NodeIOSink`.
- Added: Minimal scaffold for Link FS entities.

## 1.0.0-dev.6.0

- Upgraded to latest build_node_compilers.

## 1.0.0-dev.5.0

- Fixed deprecation warnings with Dart 2 dev 61 SDK version.

## 1.0.0-dev.4.0

- Fixed deprecation warnings with latest Dart 2 dev SDK.
- Refactored HttpHeaders to not rely on Node.js API introduced in v7.7.0
    Allows using this wrapper in Google Cloud Functions environment
    which runs on Node.js 6.x (LTS).

## 1.0.0-dev.3.0

- Allow list values in `HttpHeaders.set`.

## 1.0.0-dev.2.0

- Complete implementation of `InternetAddress`.

## 1.0.0-dev.1.0

- Split from node_interop.
