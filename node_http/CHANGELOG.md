## 1.0.0-dev.9.0

- Upgraded to build_node_compilers 0.2.0

## 1.0.0-dev.8.0

- Fixed analysis warnings with latest Pub and Dart SDK.

## 1.0.0-dev.7.0

- Added support for followRedirects.

## 1.0.0-dev.6.0

- Upgraded to latest build_node_compilers.

## 1.0.0-dev.5.0

- Fixed deprecation warnings with Dart 2 dev 61 SDK version.

## 1.0.0-dev.4.0

- Breaking: `node_http` now exports only a subset of classes from `http`
    package.
- Fixed: library-level functions aliased to those from `http` package
    which use Dart `IOClient`.

## 1.0.0-dev.3.0

- Fixed: decoding `set-cookie` header of HTTP response (#18)

## 1.0.0-dev.2.0

- Fixed: strong mode issue in converting JS response headers into a Dart `Map`.

## 1.0.0-dev.1.0

- Split from `package:node_interop/http.dart`.
