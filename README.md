# NodeJS interop library

[![Build Status](https://travis-ci.org/pulyaevskiy/node-interop.svg?branch=master)](https://travis-ci.org/pulyaevskiy/node-interop)

* [What is this?](#what-is-this?)
* [Examples](#examples)
* [Status](#status)
* [Usage](#usage)
* [Libraries](#libraries)
  * [Node Interop](#node-interop)
  * [Bindings](#bindings)
  * [HTTP](#http)
* [Pub transformer](#pub-transformer)

## What is this?

`node_interop` provides bindings for NodeJS APIs and enables writing Dart
applications and libraries which can be compiled and run in NodeJS.

In addition to bindings some modules went through "dartification" which mostly
involved:

* callbacks and/or Promises replaced with Dart Futures and Streams
* when available, Dart-specific interfaces implemented
* strongly typed everything (which sometimes means sacrificing flexibility
  of Node APIs to consistency/simplicity)

For instance, in addition to Node's [http](https://nodejs.org/api/http.html)
module bindings this package exposes "http.dart" library with HTTP client
which implements `Client` interface of Dart's [http](https://pub.dartlang.org/packages/http)
package.

Here is an example Dart app using this client:

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

Feel free to checkout `example/` folder of this repository for some example
apps using different APIs.

## Status

This package is under active development which means that you should expect
for things to change quickly. Of course breaking changes are likely to happen.
The `bindings.dart` library should be a lot less prone to breaking changes
though as it's just an interface to Node's APIs which are fairly stable at
this point.

Also libraries like `http.dart` are also unlikely to get breaking changes as
they just implement interfaces from other Dart packages which are also pretty
stable most of the time.

And there are also bugs, which haven't been found yet. If you do find one,
please create an issue in the [issue tracker](http://github.com/pulyaevskiy/node-interop/issues/new).

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
    node_interop: ^0.0.7

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
  Pub by default assumes you are building for web so it builds `web/` subfolder
  by default. So we need to explicitly tell it to look in `node/` instead:
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

This package consists of a set of libraries which can be used separately.

### Node Interop

> Usage: `import 'package:node_interop/node_interop.dart'`.

Main library which only exposes globals like `require()` and `exports` as well
as some convenience utilities.

### Bindings

> Usage: `import 'package:node_interop/bindings.dart'`.

This library exposes NodeJS API bindings as-is. Not all of the APIs are
exposed at this point, in fact, it's a small percentage. If you didn't find
a class or method you were looking for, please create an issue or submit a
pull request (even better!).

You have to explicitly `require` a Node module which declares an API you want
to use. Refer to dartdoc for more details. Here is an example if using
bindings directly:

```dart
import 'package:node_interop/bindings.dart';

void main() {
  // Require specific modules:
  FS nodeFS = require('fs');
  OS nodeOS = require('os');
  // Use globals:
  console.log('message');
}
```

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

Please file feature requests and bugs at the [issue tracker](http://github.com/pulyaevskiy/node-interop/issues/new)
