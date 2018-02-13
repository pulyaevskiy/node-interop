# node_io

This library exposes Node I/O functionality in `dart:io` way. It wraps Node.js
I/O modules (like `fs` and `http`) and implements them using abstractions 
provided by `dart:io` (like `File`, `Directory` or `HttpServer`).

> If you are looking for direct access to Node.js API see [node_interop][]
> package.

[node_interop]: https://pub.dartlang.org/packages/node_interop

## Usage

A simple usage example:

    import 'package:node_io/node_io.dart';

    main() {
      print(Directory.current);
      print("Current directory exists: ${Directory.current.existsSync()}");
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/pulyaevskiy/node-interop/issues
