# Node Interop [![Build Status](https://img.shields.io/travis/pulyaevskiy/node-interop.svg?branch=master&style=flat-square)](https://travis-ci.org/pulyaevskiy/node-interop) [![Pub](https://img.shields.io/pub/v/node_interop.svg?style=flat-square)](https://pub.dartlang.org/packages/node_interop) [![Gitter](https://img.shields.io/badge/chat-on%20gitter-c73061.svg?style=flat-square)](https://gitter.im/pulyaevskiy/node-interop)

Write applications in Dart, run in NodeJS.

* [What is this?](#what-is-this?)
* [Example](#example)
* [Structure](#structure)
* [Status](#status)

**Looking for latest updates? Make sure to check the most recent `1.0.0-dev.*` release!**

## What is this?

This library provides JavaScript bindings and some utilities to work with 
core Node APIs and built-in modules.

> To compile Dart applications as Node modules see [build_node_compilers][] 
> package.
> 
> For a more Dart-like experience with Node I/O system see 
> [node_io][] package which is designed as a drop-in replacement for `dart:io`.
>
> For a Dart-style HTTP client checkout [node_http][].

[build_node_compilers]: https://pub.dartlang.org/packages/build_node_compilers
[node_io]: https://pub.dartlang.org/packages/node_io
[node_http]: https://pub.dartlang.org/packages/node_http

## Example

Here is an example Node app written in Dart:

```dart
import 'package:node_interop/node.dart';

void main() {
  print("Hello world, I'm currently in ${process.cwd()}.");
}
```

This application can be compiled with [build_node_compilers][] and executed in 
Node.

For more examples using different APIs see `example/` folder.

## Structure

For each built-in Node module there is a separate Dart file in the `lib/`
folder. So to access Node's `os` module, for instance, you'd need to use
following import:

```dart
import 'package:node_interop/os.dart';
```

Note that after importing a module like above there is no need to also `require`
it (the Node way). Each library file (like `os.dart`) exposes library-level
property of the same name which gives you access to that module's functionality.
This is just a convenience to not have to `import` *and* `require` modules at 
the same time. Here is how `os.dart` implements it:

```dart
// file:lib/os.dart
@JS()
library node_interop.os;

import 'package:js/js.dart';

import 'node.dart';

OS get os => require('os');

@JS()
@anonymous
abstract class OS {
  external List<CPU> cpus();
  // ...
}
```

Not all built-in Node modules need to be required, like `buffer` module for
instance. They still have a dedicated Dart file in this library, but this is 
mostly for consistency and you shouldn't need to import it directly. The 
`buffer` module is globally available in Node.

Libraries with underscores in their name (like `child_process`) expose 
library-level property with underscores converted to camelCase to be compliant 
with Dart code style rules:

```dart
import 'package:node_interop/child_process.dart';

void main() {
  childProcess.execSync('ls -la');
}
```

## Note on creating native Node.js objects

Most of the objects in Node.js are not global therefore they are declared as
`@anonymous` in this library. Unfortunately this prevents us from instantiating
new instances by simply using `new Something()`.

As a workaround for this problem each module provides a `createX()` library
function. For instance, `stream` module provides `createReadable` and
`createWritable` for creating custom `Readable` and `Writable` streams:

```dart

import 'dart:js_util'; // provides callConstructor()

/// The "stream" module's object as returned from [require] call.
StreamModule get stream => _stream ??= require('stream');
StreamModule _stream;

@JS()
@anonymous
abstract class StreamModule {
  /// Reference to constructor function of [Writable].
  dynamic get Writable;

  /// Reference to constructor function of [Readable].
  dynamic get Readable;
}

/// Creates custom [Writable] stream with provided [options].
///
/// This is the same as `callConstructor(stream.Writable, [options]);`.
Writable createWritable(WritableOptions options) {
  return callConstructor(stream.Writable, [options]);
}
```

## Status

Version 1.0.0 is considered stable though not feature complete. It is recommended to check
`1.0.0-dev.*` versions for latest updates and bug fixes.

Make sure to checkout [CHANGELOG.md][changelog] after every release, all 
notable changes and upgrade instructions will be described there.

If you found a bug, please don't hesitate to create an issue in the
[issue tracker][issue_tracker].

[changelog]: https://github.com/pulyaevskiy/node-interop/blob/master/node_interop/CHANGELOG.md
[issue_tracker]: http://github.com/pulyaevskiy/node-interop/issues/new

Below is a list of built-in Node.js modules this library already provides
bindings for:

- [x] buffer
- [x] child_process
- [ ] cluster
- [x] console
- [x] dns
- [ ] domain
- [x] events
- [x] fs
- [x] http
- [x] https
- [x] module
- [x] net
- [x] os
- [x] path
- [x] process
- [x] querystring
- [ ] readline
- [x] stream
- [ ] string_decoder
- [x] timers
- [x] tls
- [ ] tty
- [ ] dgram
- [ ] url
- [ ] util
- [ ] v8
- [ ] vm
- [ ] zlib

## Features and bugs

Please file feature requests and bugs at the [issue tracker][issue_tracker].
