# NodeJS interop library

Provides interface bindings for NodeJS APIs and allows writing Dart
applications and libraries which can be compiled and used in NodeJS.

## Usage

How to write a simple Node app written in Dart:

1. Create a new Dart project. Stagehand is a great way to scaffold all the
  boilerplate.
  ```bash
  pub global activate stagehand
  mkdir my_node_app
  cd my_node_app
  stagehand package-simple # if you have .pub-cache in your PATH, or
  pub global run stagehand package-simple # if you don't have it in your PATH
  ```
2. Add dependency and transformers to the generated `pubspec.yaml`
  ```yaml
  dependencies:
    node_interop: any

  transformers:
    - $dart2js
    - node_interop
  ```
3. Create `bin/main.dart` and write some code. 
  ```dart
  import 'package:node_interop/node_interop.dart';
  import 'package:node_interop/fs.dart';

  void main() {
    var fs = new NodeFileSystem(); // access Node `fs` module
    print(fs.currentDirectory); // prints the path from `process.cwd()`
    print(fs.currentDirectory.listSync()); // lists current directory contents
  }
  ```
4. **Compile.**
  Pub by default assumes you are building for web and looks for `web` folder so we need to explicitely tell it to look in the `bin/` where our `main.dart` is.
  ```bash
  $ pub build bin
  ```
5. **Run the app.** Compiled app is located in `build/bin/main.dart.js`:
  ```bash
  $ node build/bin/main.dart.js
  $ # If everything worked well you should see your current 
  $ # directory contents printed out.
  ```

## Build and Pub transformers

This library provides Pub transformer which by default looks only for file named `bin/main.dart` to prepend Node preamble to.

## Features and bugs

Please file feature requests and bugs at the [issue tracker](http://github.com/pulyaevskiy/node-interop/issues/new)
