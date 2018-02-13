// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io' as io;

import 'package:js/js.dart';
import 'package:node_interop/dns.dart';
import 'package:node_interop/net.dart';

export 'dart:io' show InternetAddressType;

const _kLoopbackIPv4 = '127.0.0.1';
const _kLoopbackIPv6 = '::1';

class InternetAddress implements io.InternetAddress {
  final String _host;

  @override
  final String address;

  @override
  String get host => _host ?? address;

  @override
  io.InternetAddressType get type => net.isIPv4(address)
      ? io.InternetAddressType.IP_V4
      : io.InternetAddressType.IP_V6;

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
    if (type == io.InternetAddressType.IP_V4) {
      List<int> raw = rawAddress;
      return raw[0] == 169 && raw[1] == 254 && raw[3] >= 1 && raw[3] <= 254;
    } else {
      throw new UnimplementedError();
    }
  }

  @override
  bool get isLoopback =>
      (type == io.InternetAddressType.IP_V4 && address == _kLoopbackIPv4) ||
      (type == io.InternetAddressType.IP_V6 && address == _kLoopbackIPv6);

  @override
  bool get isMulticast => throw new UnimplementedError();

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
    throw new UnimplementedError();
  }

  @override
  String toString() => '$address';
}
