// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@TestOn('node')
library internet_address_test;

import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

void main() {
  group('InternetAddress', () {
    test('lookup successful', () async {
      var list = await InternetAddress.lookup('google.com');
      expect(list, isNotEmpty);
      expect(list.first.type, equals(InternetAddressType.IP_V4));
    });
  });
}
