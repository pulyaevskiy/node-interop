// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library console_test;

import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';
import 'package:test/test.dart';

void main() {
  group('console', () {
    test('bindings', () async {
      // TODO: is there a way to "expect" here? `prints` matcher doesn't work
      // For now just check that JS binding works.
      console.log('test log');
      console.error('test log');
      console.info('test log');
      console.warn('test log');
      console.log('test log');
    });
  });
}
