// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';

// Simple example using FS bindings.
main() {
  FS fs  = node.require('fs');
  fs.readdir(process.cwd(), allowInterop((error, files) {
    print(files);
  }));
}
