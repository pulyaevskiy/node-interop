# NodeJS interop library [![Build Status](https://img.shields.io/travis-ci/pulyaevskiy/node-interop.svg?branch=master&style=flat-square)](https://travis-ci.org/pulyaevskiy/node-interop) [![Pub](https://img.shields.io/pub/v/node_interop.svg?style=flat-square)](https://pub.dartlang.org/packages/node_interop) [![Gitter](https://img.shields.io/badge/chat-on%20gitter-c73061.svg?style=flat-square)](https://gitter.im/pulyaevskiy/node-interop)

Write applications in Dart, run in NodeJS. This is an early preview,
alpha open-source project.

* [What is this?](#what-is-this?)
* [Status](#status)

## What is this?

`node_interop` provides JavaScript bindings and enables running Dart
applications in NodeJS.

> For a more DartSDK-like experience see the new [node_io][node_io_github]
> library which is designed as a direct replacement for `dart:io`.
> For a Dart-style HTTP client checkout [node_http][node_http_github].

[node_io_github]: https://github.com/pulyaevskiy/node-io
[node_http_github]: https://github.com/pulyaevskiy/node-http

## Status

This library is currently in alpha and breaking changes are very likely.

Active development is happening on the `1.0.0-dev` version (`dart20` branch)
which includes:

- Depends on Dart SDK >= 2.0.0-dev
- Supports new `build_runner` system
- Supports both DDC and dart2js
- Removes all higher-level abstractions to separate libraries 
  (node_io and node_http) so that this library only provides JS API bindings
  and some utilities.

Make sure to checkout [CHANGELOG.md][changelog] after every release, all 
notable changes and upgrade instructions will be described there.

If you found a bug, please don't hesitate to create an issue in the
[issue tracker][issue_tracker].

[changelog]: https://github.com/pulyaevskiy/node-interop/blob/master/CHANGELOG.md
[issue_tracker]: http://github.com/pulyaevskiy/node-interop/issues/new

## Features and bugs

Please file feature requests and bugs at the [issue tracker][issue_tracker].
