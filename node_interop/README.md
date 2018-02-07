# Node Interop [![Build Status](https://img.shields.io/travis-ci/pulyaevskiy/node-interop.svg?branch=master&style=flat-square)](https://travis-ci.org/pulyaevskiy/node-interop) [![Pub](https://img.shields.io/pub/v/node_interop.svg?style=flat-square)](https://pub.dartlang.org/packages/node_interop) [![Gitter](https://img.shields.io/badge/chat-on%20gitter-c73061.svg?style=flat-square)](https://gitter.im/pulyaevskiy/node-interop)

Write applications in Dart, run in NodeJS.

* [What is this?](#what-is-this?)
* [Status](#status)

## What is this?

This library provides JavaScript bindings and some utilities to work with 
core Node APIs and built-in modules.

> To compile Dart applications as Node modules see 
> [build_node_compilers][build_node_compilers_pub] package.
> 
> For a more Dart-like experience with Node I/O system see 
> [node_io][node_io_pub] package which is designed as a drop-in replacement 
> for `dart:io`.
>
> For a Dart-style HTTP client checkout [node_http][node_http_pub].

[build_node_compilers_pub]: https://pub.dartlang.org/packages/build_node_compilers
[node_io_pub]: https://pub.dartlang.org/packages/node_io
[node_http_pub]: https://pub.dartlang.org/packages/node_http

## Status

`1.0.0-dev` version is under active development and includes many changes:

- Depends on Dart SDK >= 2.0.0-dev
- Supports new `build_runner` system
- Supports both DDC and dart2js
- Removes all higher-level abstractions to separate libraries 
  (node_io and node_http) so that this library only provides JS API bindings
  and some utilities.

While 1.0.0 is still in `dev` mode breaking changes are likely to occur.

Make sure to checkout [CHANGELOG.md][changelog] after every release, all 
notable changes and upgrade instructions will be described there.

If you found a bug, please don't hesitate to create an issue in the
[issue tracker][issue_tracker].

[changelog]: https://github.com/pulyaevskiy/node-interop/blob/master/node_interop/CHANGELOG.md
[issue_tracker]: http://github.com/pulyaevskiy/node-interop/issues/new

## Features and bugs

Please file feature requests and bugs at the [issue tracker][issue_tracker].
