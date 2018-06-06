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
