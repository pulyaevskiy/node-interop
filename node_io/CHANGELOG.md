## 1.0.0-dev.7.0

- Fixed: handling errors in `Directory.delete`.
- Fixed: handling relative paths in `Directory.list`.
- Updated: `Directory.list` silently skips link FS entries which are not implemented yet.
- Fixed: strong mode issues in `Directory` and `File`.
- Added: `File.create`, `File.delete`, `File.readAsString`, `File.rename`,
    `File.writeAsBytes`, `File.writeAsString`.
- Fixed: handling errors in `File.open`, `File.stat`, `File.statSync`.
- Fixed: converting byte data in `NodeIOSink`.

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
