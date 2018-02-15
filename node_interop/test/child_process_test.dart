// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js';

@TestOn('node')
import 'package:node_interop/child_process.dart';
import 'package:test/test.dart';

void main() {
  group('child_process', () {
    test('exec successful', () {
      Completer<int> completer = new Completer<int>();
      childProcess.exec('ls -la', new ExecOptions(),
          allowInterop((error, stdout, stderr) {
        int result = (error == null) ? 0 : error.code;
        completer.complete(result);
      }));
      expect(completer.future, completion(0));
    });
  });
}
