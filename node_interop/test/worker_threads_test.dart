// Copyright (c) 2020, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')

import 'dart:async';

import 'package:js/js.dart';
import 'package:node_interop/util.dart';
import 'package:node_interop/worker_threads.dart';
import 'package:test/test.dart';

void main() {
  test('createWorkerThread', () {
    final worker = createWorker('''
        const worker = require('worker_threads');

        worker.parentPort.on('message',
            (message) => worker.parentPort.postMessage(message + 1));
      ''', WorkerOptions(eval: true));

    worker.postMessage(12);
    worker.on('message',
        allowInterop(Zone.current.bindUnaryCallback(expectAsync1((message) {
      expect(message, equals(13));
      var result = worker.terminate();
      if (result != null) expect(promiseToFuture(result), completes);
    }))));
  });
}
