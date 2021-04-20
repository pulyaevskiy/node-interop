// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// @dart=2.9

@TestOn('node')
library internet_address_test;

import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

void main() {
  group('InternetAddress', () {
    test('rawAddress', () {
      var addr = InternetAddress('127.0.0.1');
      expect(addr.rawAddress, [127, 0, 0, 1]);

      addr = InternetAddress('2606:2800:220:1:248:1893:25c8:1946');
      expect(addr.rawAddress, [
        0x26, 0x6, 0x28, 0x0, 0x2, 0x20, 0x0, 0x1, 0x2, //nofmt
        0x48, 0x18, 0x93, 0x25, 0xc8, 0x19, 0x46
      ]);

      addr = InternetAddress('2001:41c0::645:a65e:60ff:feda:589d');
      expect(addr.rawAddress, [
        0x20, 0x1, 0x41, 0xc0, 0x0, 0x0, 0x6, 0x45, 0xa6, // nofmt
        0x5e, 0x60, 0xff, 0xfe, 0xda, 0x58, 0x9d
      ]);
      addr = InternetAddress('2001:0db8::1:0:0:1');
      expect(addr.rawAddress, [
        0x20, 0x1, 0xd, 0xb8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, // nofmt
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1
      ]);
      addr = InternetAddress('2001:41c0::1');
      expect(addr.rawAddress, [
        0x20, 0x1, 0x41, 0xc0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, // nofmt
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1
      ]);
      addr = InternetAddress('2606::1');
      expect(addr.rawAddress, [
        0x26, 0x6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, // nomft
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1
      ]);
      addr = InternetAddress('1000::1');
      expect(addr.rawAddress, [
        0x10, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, // nofmt
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1
      ]);
      addr = InternetAddress('::1');
      expect(addr.rawAddress, [
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, // nofmt
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1
      ]);
      addr = InternetAddress('::');
      expect(addr.rawAddress, [
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, // nofmt
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0
      ]);
    });

    test('lookup successful', () async {
      var list = (await InternetAddress.lookup('google.com'))
          .map((address) => address.type);
      expect(list.contains(InternetAddressType.IPv4), equals(true));
      expect(list.contains(InternetAddressType.IPv6), equals(true));
    });

    test('reverse successful', () async {
      final ip = InternetAddress('8.8.8.8');
      final reversed = await ip.reverse();
      expect(reversed.address, equals('8.8.8.8'));
      expect(reversed.host, contains('google'));
    });
  });
}
