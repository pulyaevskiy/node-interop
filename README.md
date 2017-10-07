# NodeJS interop library

[![Build Status](https://img.shields.io/travis-ci/pulyaevskiy/node-interop.svg?branch=master&style=flat-square)](https://travis-ci.org/pulyaevskiy/node-interop) [![Pub](https://img.shields.io/pub/v/node_interop.svg?style=flat-square)](https://pub.dartlang.org/packages/node_interop) [![Gitter](https://img.shields.io/badge/chat-on%20gitter-c73061.svg?style=flat-square)](https://gitter.im/pulyaevskiy/node-interop)

* [What is this?](#what-is-this?)
* [Examples](#examples)
* [Status](#status)
* [Usage](#usage)
* [Libraries](#libraries)
  * [Node Interop](#node-interop)
  * [FS](#fs)
  * [HTTP](#http)
* [Pub transformer](#pub-transformer)

## What is this?

`node_interop` provides NodeJS API bindings and enables running Dart
applications in NodeJS.

In addition to bindings some modules are also exposed as idiomatic Dart
libraries. For instance, in addition to Node's [http](https://nodejs.org/api/http.html)
module bindings this package provides a HTTP client implementation
based on Dart's [http](https://pub.dartlang.org/packages/http) package.

Here is an example app using this client:

```dart
import 'package:node_interop/http.dart';

void main() async {
  var http = new NodeClient();
  var response = await http.get('https://example.com');
  print("Response code: ${response.statusCode}.");
  http.close(); // close any open IO connections.
}
```

There is not much Node or JS specific about this app, it looks like a
regular Dart app. This is pretty much why `node_interop` exists.

## Examples

Checkout `example/` folder of this repository for some example
apps using different APIs.

## Status

This package is under active development which means things are likely to
change rather rapidly.

Make sure to checkout [CHANGELOG.md](CHANGELOG.md) for every release, all
notable changes and upgrade instructions will be announced there.

If you found a bug, please don't hesitate to create an issue in the
[issue tracker](http://github.com/pulyaevskiy/node-interop/issues/new).

## Usage

How to create a simple Node app written in Dart:

1. Create a new Dart project. [Stagehand](http://stagehand.pub) is a great way
  to scaffold all the boilerplate:
  ```bash
  $ pub global activate stagehand
  $ mkdir my_node_app
  $ cd my_node_app
  $ stagehand package-simple # if you have .pub-cache in your PATH, or
  $ pub global run stagehand package-simple # if you don't have it in your PATH
  ```
2. Add dependency and transformers to the generated `pubspec.yaml`
  ```yaml
  dependencies:
    node_interop: ^0.1.0

  transformers:
    - $dart2js
    - node_interop # <- must go after dart2js!
  ```
3. Create `node/main.dart` and write some code:
  ```dart
  import 'package:node_interop/fs.dart';

  void main() async {
    var fs = new NodeFileSystem(); // access Node `fs` module
    print(fs.currentDirectory); // prints the path from `process.cwd()`
    var files = await fs.currentDirectory.list().toList();
    print(files); // lists current directory contents
  }
  ```
4. **Compile.**
  Tell Pub to build `node/` folder:
  ```bash
  $ pub build node/
  ```
5. **Run the app.** Compiled app is located in `build/node/main.dart.js`:
  ```bash
  $ # assuming you have NodeJS installed:
  $ node build/bin/main.dart.js
  $ # If everything worked well you should see your current
  $ # directory contents printed out.
  ```

## Libraries

This package consists of a set of libraries.

### Node Interop

> `import 'package:node_interop/node_interop.dart'`.

Main library which provides NodeJS API bindings as-is. Not all of the APIs are
implemented at this point, in fact, it's a small percentage. If you didn't find
a class or method you were looking for, please create an issue or submit a
pull request (even better!).

You have to explicitly `require` a Node module which declares an API you want
to use. Refer to dartdoc for more details. Here is an example if using
bindings directly:

```dart
import 'package:node_interop/node_interop.dart';

void main() {
  // Require specific modules:
  FS nodeFS = require('fs');
  OS nodeOS = require('os');
  // Use globals:
  console.log('message');
}
```

Note that bindings provide direct access to JavaScript objects and functions and
you still need to make sure objects are properly converted when passed
between Dart and JS parts of the app, as well as Dart functions are wrapped with
`allowInterop` when passed to JS.

This is why it is recommended to use "dartified" libraries described below, as
they take care of all details communicating with JavaScript side of your app.

### FS

> `import 'package:node_interop/fs.dart'`.

Exposes Node's file system API as a set of Dart classes compatible with
interfaces from "dart:io" (in particular it implements interfaces provided by
the [file](https://pub.dartlang.org/packages/file) package).

_Note that not all methods are currently implemented for `File` and `Directory`
classes._

### HTTP

> `import 'package:node_interop/http.dart'`.

Implements Dart-style HTTP client using [http](https://pub.dartlang.org/packages/file)
package interface.

## Pub transformer

This library provides Pub transformer which by default processes all `.dart`
files. The only thing it does is it prepends Node preamble to JS generated by
dart2js transformer.

## NodeJS modules and `exports`

It is possible to create a module which exposes some functionality via NodeJS
`exports`.

Here is simple module example exporting a `bang` function:

```dart
// file:bin/bang.dart
import 'package:node_interop/node_interop.dart';

/// A module which exports a bang function.
void main() {
  exports.setProperty('bang', bang);
}

String bang(String value) {
  return value.toUpperCase() + '!';
}
```

After compiled with `pub build` it can be `require`d from any JS file:

```js
const bang = require('path/to/build/bin/bang.dart.js');
console.log(bang.bang('Hi'));
// prints out "HI!"
```

> For such a small function the resulting `bang.dart.js` would be quite
> large (~1k lines of code). However creating Node modules like this can
> be considered an edge use case when you would want to mix in some
> functionality from Dart into an existing Node app.

## Features and bugs

Please file feature requests and bugs at the
[issue tracker](http://github.com/pulyaevskiy/node-interop/issues/new)
