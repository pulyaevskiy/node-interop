// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io' as io;
import 'dart:js';

import 'package:node_interop/dns.dart';
import 'package:node_interop/net.dart';

export 'dart:io' show InternetAddressType;

const _kLoopbackIPv4 = '127.0.0.1';
const _kLoopbackIPv6 = '::1';

class InternetAddress implements io.InternetAddress {
  static const int _IPV6_ADDR_LENGTH = 16;

  final String _host;

  @override
  final String address;

  @override
  String get host => _host ?? address;

  @override
  io.InternetAddressType get type => net.isIPv4(address)
      ? io.InternetAddressType.IP_V4
      : io.InternetAddressType.IP_V6;

  // This probably shouldn't have been in the interface because dart:io
  // version does not implement this setter.
  @override
  set type(io.InternetAddressType value) =>
      throw new UnsupportedError('Setting address type is not supported.');

  InternetAddress._(this.address, [this._host]) {
    if (net.isIP(address) == 0)
      throw new ArgumentError('${address} is not valid.');
  }

  factory InternetAddress(String address) => new InternetAddress._(address);

  static Future<List<io.InternetAddress>> lookup(String host) {
    Completer<List<io.InternetAddress>> completer = new Completer();
    var options = new DNSLookupOptions(all: true, verbatim: true);

    void handleLookup(error, List<DNSAddress> addresses) {
      if (error != null) {
        completer.completeError(error);
      } else {
        var list = addresses
            .map((item) => new InternetAddress._(item.address, host))
            .toList(growable: false);
        completer.complete(list);
      }
    }

    dns.lookup(host, options, allowInterop(handleLookup));
    return completer.future;
  }

  @override
  bool get isLinkLocal {
    final List<int> raw = rawAddress;
    // Copied from dart:io
    switch (type) {
      case io.InternetAddressType.IP_V4:
        // Checking for 169.254.0.0/16.
        return raw[0] == 169 && raw[1] == 254;
      case io.InternetAddressType.IP_V6:
        // Checking for fe80::/10.
        return raw[0] == 0xFE && (raw[1] & 0xB0) == 0x80;
    }
    throw new StateError('Unreachable');
  }

  @override
  bool get isLoopback {
    final List<int> raw = rawAddress;
    // Copied from dart:io
    switch (type) {
      case io.InternetAddressType.IP_V4:
        return raw[0] == 127;
      case io.InternetAddressType.IP_V6:
        for (int i = 0; i < _IPV6_ADDR_LENGTH - 1; i++) {
          if (raw[i] != 0) return false;
        }
        return raw[_IPV6_ADDR_LENGTH - 1] == 1;
    }
    throw new StateError('Unreachable');
  }

  @override
  bool get isMulticast {
    // Copied from dart:io
    switch (type) {
      case io.InternetAddressType.IP_V4:
        // Checking for 224.0.0.0 through 239.255.255.255.
        return rawAddress[0] >= 224 && rawAddress[0] < 240;
      case io.InternetAddressType.IP_V6:
        // Checking for ff00::/8.
        return rawAddress[0] == 0xFF;
    }
    throw new StateError('Unreachable');
  }

  @override
  List<int> get rawAddress {
    if (_rawAddress != null) return new List.from(_rawAddress);
    if (type == io.InternetAddressType.IP_V4) {
      _rawAddress = address.split('.').map(int.parse).toList(growable: false);
    } else {
      throw new UnimplementedError();
    }
    return new List.from(_rawAddress);
  }

  List<int> _rawAddress;

  @override
  Future<io.InternetAddress> reverse() {
    // dns.rever
    throw new UnimplementedError();
  }

  @override
  String toString() => '$address';
}
