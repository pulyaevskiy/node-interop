// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@TestOn('node')
import 'package:node_interop/node_interop.dart';
import 'package:node_interop/src/internet_address.dart';
import 'package:test/test.dart';

final HTTP nodeHTTP = require('http');

void main() {
  group('InternetAddress', () {
    test('lookup successful', () async {
      var list = await InternetAddress.lookup('google.com');
      expect(list, isNotEmpty);
      expect(list.first.type, equals(InternetAddressType.IP_V4));
    });
  });
}
