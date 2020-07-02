// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js';

import 'package:node_interop/console.dart';
import 'package:node_interop/stream.dart';

/// Example of creating custom [Console] instance which forwards all records
/// to Dart's `print` function. One could use it in tests with `prints` matcher,
/// for instance.
///
/// This example also showcases how to create a custom [Writable] stream.
void main() {
  final console = createConsole(createPrintStream());
  console.log('Hello world');
}

Writable createPrintStream() {
  return createWritable(WritableOptions(
    decodeStrings: false,
    write: allowInterop((String chunk, encoding, Function callback) {
      // Removes extra line-break added by `console.log`.
      print(chunk.substring(0, chunk.length - 1));
      callback();
    }),
  ));
}
