## 1.0.0

- Complete file system implementations for `Directory`, `File`, `RandomAccessFile`
- Added `STATUS.md` which reflects coverage of already implemented `dart:io` APIs.

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
