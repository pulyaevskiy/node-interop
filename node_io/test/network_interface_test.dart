// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// @dart=2.9

@TestOn('node')
library network_interface_test;

import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

void main() {
  group('NetworkInterface', () {
    test('list', () async {
      var result = await NetworkInterface.list();
      expect(result, isNotEmpty);
    });
  });
}
