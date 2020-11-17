# node_io

This library exposes Node I/O functionality in `dart:io` way. It wraps Node.js
I/O modules (like `fs` and `http`) and implements them using abstractions 
provided by `dart:io` (like `File`, `Directory` or `HttpServer`).

> If you are looking for direct access to Node.js API see [node_interop][]
> package.

[node_interop]: https://pub.dartlang.org/packages/node_interop

## Usage

A basic example of accessing file system:

```dart
import 'package:node_io/node_io.dart';

void main() {
  print(Directory.current);
  print("Current directory exists: ${Directory.current.existsSync()}");
  print('Current directory contents: ');
  Directory.current.list().listen(print);
}
```

## FileSystem API

This package provides a [`nodeFileSystem`] field that implements the `file`
package's [`FileSystem`] API. This makes it possible to configure APIs written
to work with generic filesystems to work with `node_io` in particular.

[`nodeFileSystem`]: https://pub.dev/documentation/node_io/latest/node_io/nodeFileSystem.html
[`FileSystem`]: https://pub.dev/documentation/file/latest/file/FileSystem-class.html

## Configuration and build

Add `build_node_compilers` and `build_runner` to `dev_dependencies` section 
in `pubspec.yaml` of your project:

```yaml
dev_dependencies:
  build_runner: # needed to run the build
  build_node_compilers:
```

Add `build.yaml` file to the root of your project:

```yaml
targets:
  $default:
    sources:
      - "node/**"
      - "test/**" # Include this if you want to compile tests.
      - "example/**" # Include this if you want to compile examples.
```

By convention all Dart files which declare `main` function go in `node/` folder.

To build your project run following:

```bash
pub run build_runner build --output=build/
```

Detailed instructions can be found in [build_node_compilers][] package docs.

[build_node_compilers]: https://pub.dartlang.org/packages/build_node_compilers

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/pulyaevskiy/node-interop/issues
