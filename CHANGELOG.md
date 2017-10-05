# Changelog

## 0.1.0

- **Breaking changes:**
  - `NodePlatform` is no longer exported from `node_interop.dart` library.
  - Library-level `exports` getter was removed. Now  `exports` is a direct reference
    to native JS object. Replace any calls to `exports.setProperty(name, value)`
    with new API: `node.export(name, value)`.
- **Deprecated:**
  - `node_interop/bindings.dart` is deprecated and will be removed in 0.2.0.
    All bindings are available through main `node_interop/node_interop.dart`
    import.
- **New:**
  - Many updates to documentation.
  - Main package's library now exposes all (implemented) Node API bindings.
  - New `node` library object with centralized access to the Node platform and
    runtime information, which also exposes helpers for `require` and `exports`.

## 0.0.7

- Added `node_interop/test.dart` library with `installNodeModules()`
  helper function. See dartdoc for more details.

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
