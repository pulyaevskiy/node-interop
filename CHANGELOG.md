# Changelog

## 0.0.6

- `jsObjectToMap`: added null-check.
- Added basic HTTP client implementation for Node, based on an interface
  from 'http' package. Use with `import package:node_interop/http.dart`.

## 0.0.5

- Streamlined bindings layer and exposed as it's own library. Use
  `import package:node_interop/bindings.dart` to get access.
- Added bindings for 'http' module (work in progress).

## 0.0.4

- Upgraded to `test` package with support for running tests in Node
- Implemented `NodeFileSystem.file()` and `File.writeAsStringSync()`.

## 0.0.3

- Added bindings for `Console`.

## 0.0.2

- Switched to use official `node_preamble` package

## 0.0.1

- Initial version
