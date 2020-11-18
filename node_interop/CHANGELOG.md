## 1.2.1

- Add `util.callbackToCompleter()`, `util.invokeAsync0()`, and `util.invokeAsync1()`
  helpers to make it easier to work with Node-style callbacks.

## 1.2.0

- Added worker_threads module bindings (#84)
- Added interop for Atomics (#85)

## 1.1.1

- Added missing method definitions for TTYWriteStream.

## 1.1.0

- Added bindings for Node.js `tty` module as well as updated Process bindings for `stdout`,
  `stdin` and `stderr` to return TTY stream types instead of `Writable` and `Readable`.

## 1.0.3

- Removed generic annotations from Process methods per #56 (not supported by Dart yet).
- Added `util.inspect` binding.

## 1.0.2

- Clarified documentation of `dartify` regarding conversion of JS object keys (#52).

## 1.0.1

- Fixed declaration of `fs.writeSync` and `fs.readSync` to return `int` instead of `void`.

## 1.0.0

No functional changes in this version, it is published to replace obsolete `0.0.7` version on the
Pub's package homepage to improve discoverability.

Ongoing work will continue in `1.0.0-dev.*` branch until it's considered stable and feature complete.
Make sure to checkout recent dev version for latest updates.

Non-breaking changes may be published to the stable track periodically.

## 1.0.0-dev.13.0

- Added `HttpsAgentOptions` with basic TLS/SSL parameters.
- Breaking: createHttpsAgent() now expects instance of `HttpsAgentOptions` instead of `HttpAgentOptions`.

## 1.0.0-dev.12.0

- Fixed Console method bindings to not force `String` arguments and allow any type.
- Breaking: Updated `JsError` constructor definition to match Node.js documentation.

## 1.0.0-dev.11.0

- Upgraded to build_node_compilers 0.2.0

## 1.0.0-dev.10.0

- Internal changes.

## 1.0.0-dev.9.0

- Fixed analysis warnings.

## 1.0.0-dev.8.0

- Upgraded to latest build_node_compilers.

## 1.0.0-dev.7.0

- Fixed: Changed `ServerResponse.getHeader` return type from `String` to
    `dynamic`.

## 1.0.0-dev.6.0

- Added: binding for JS `undefined` value in `node_interop/js.dart`.

## 1.0.0-dev.5.0

- Fixed: strong mode issue in `dartify` utility function when converting plain
  JS objects to Dart `Map`. Returned map is now of type `Map<String, dynamic>`
  instead of `Map`.

## 1.0.0-dev.4.0

- Fixed: strong mode issue in `promiseToFuture` utility function.
- Fixed: signature of `fs.realpathSync`.

## 1.0.0-dev.3.0

- Added or completed bindings for following Node.js modules: `dns`, `events`,
  `fs`, `http`, `https`, `module`, `net`, `os`, `path`, `process`,
  `querystring`, `stream`, `timers`, `tls`.
- Added more examples and tests.

## 1.0.0-dev.2.0

- Completed `dns` module function definitions (still missing data structures).

## 1.0.0-dev.1.0+1

- Minor internal changes.

## 1.0.0-dev.1.0

### Breaking changes:

- node_interop depends on Dart 2 SDK which allows us to leverage new
  build_runner system and move away from Pub transformers.
- Removed Pub transformer, which means you shouldn't need it in your
  `pubspec.yaml` anymore. Build system is now based on `build` package. See docs
  for more details.
- node_interop no longer exports Dart-specific abstractions like an HTTP client
  or FileSystem. These abstractions have been moved to separate packages:
  `node_io` and `node_http`. This way node_interop now only exposes JS bindings
  for Node and some utility functions.
- library structure is changed to map closer to built-in Node modules. There is
  a separate file for each module which exposes that module's bindings,
  e.g. `fs.dart`, `http.dart`.
- `node` object has been removed. Can use `require` and `exports` functions
  directly. There is also new convenience function `setExport`.
- `jsPromiseToFuture` renamed to `promiseToFuture`.
- `futureToJsPromise` renamed to `futureToPromise`.
- `jsObjectKeys` renamed to `objectKeys`.
- `dartify` now allows converting JS `function` objects.
- `JsPromise

## 0.1.0-beta.9

- Added library-level `get` function to `http.dart`.

## 0.1.0-beta.8+1

- Updated changelog.

## 0.1.0-beta.8

- Introduced new `io.dart` library designed to follow `dart:io` contract.
- Breaking: renamed `HttpRequest` exposed by `http.dart` to
    `NodeHttpRequest`. This is a server-side request object which will
    eventually be hidden from this library. It is recommended to import
    new `io.dart` which exposes both `HttpRequest` and `NodeHttpRequest`
    objects.

## 0.1.0-beta.7

- Fix HttpHeaders.forEach crash when called on HttpRequest.headers [#6]

## 0.1.0-beta.6

- **Breaking:**
  - renamed `ReadableStream.nativeStream` to `ReadableStream.nativeInstance`
  - renamed `WritableStream.nativeStream` to `WritableStream.nativeInstance`
- **New**:
  - Added `jsonStringify` and `jsonParse` which bind to native
    `JSON.stringify` and `JSON.parse` respectively.

## 0.1.0-beta.5

- Fixed: `HttpResponse.close()` failed when trying to finalize headers.

## 0.1.0-beta.4

- Made `Promise<T>` a generic type. Also added definition of `Thenable`.
- `onRejected` in `Promise.then` is now optional.
- Added explicit type to `node` variable.

## 0.1.0-beta.3

- More updates to bindings.
- Added new `async.dart` library with basic implementations of
  `ReadableStream<T>`, `WritableStream<T>` and `NodeIOSink`.
- Added implementations of server side `HttpRequest` and `HttpResponse`
  to `http.dart`, as well some other objects like `HttpHeaders`.
- Added `dartifyError(JsError error)` to the main library which converts
  from JS `Error` instances in to Dart's equivalent.
- Implemented more methods in `File`: `openRead`, `openWrite`, `readAsBytes`.
- Deprecated `createJSFile` in `test.dart` library. Use `createFile` instead.

## 0.1.0-beta.2

- `jsObjectToMap` deprecated. There is new helper function `dartify`.
  See documentation for more details.
- New `jsify` helper function.
- Clarified type of HTTP server `requestListener`.
- New `createJSFile` test util in `test.dart`.

## 0.1.0-beta.1

- **Breaking changes:**
  - `NodePlatform` is no longer exported from `node_interop.dart` library.
  - Library-level `exports` getter was removed. Now  `exports` is a direct reference
    to native JS object. Replace any calls to `exports.setProperty(name, value)`
    with new API: `node.export(name, value)`.
  - "http" module: `Agent`, `Server`, `AgentOptions` renamed to
    `HttpAgent`, `HttpServer`, `HttpAgentOptions` respectively.
  - "http" module: `createAgent` renamed to `createHttpAgent`.
  - `node_interop/bindings.dart` was removed. All bindings are available
    through main `node_interop/node_interop.dart` import.
- **New:**
  - Many updates to documentation.
  - Main package's library now exposes all (implemented) Node API bindings.
  - New `node` library object with centralized access to the Node platform and
    runtime information, as well as module globals like `require` and `exports`.
  - Exposed parts of "https", "tls", "dns" and "net" module bindings.
  - Added HTTPS support to `NodeClient` from `node_interop/http.dart`.
  - Updated examples.
  - Gitter channel is now up: https://gitter.im/pulyaevskiy/node-interop.

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
