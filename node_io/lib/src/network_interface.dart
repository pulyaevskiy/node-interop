// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io' as io;

import 'package:node_interop/os.dart';
import 'package:node_interop/util.dart';

import 'internet_address.dart';

/// A [NetworkInterface] represents an active network interface on the current
/// system. It contains a list of [InternetAddress]es that are bound to the
/// interface.
abstract class NetworkInterface implements io.NetworkInterface {
  /// Whether [list] is supported.
  static bool get listSupported => true;

  /// Query the system for [NetworkInterface]s.
  // TODO: Implement all named arguments for this method.
  static Future<List<io.NetworkInterface>> list() {
    // ignore: omit_local_variable_types
    final Map<String, Object> data = dartify(os.networkInterfaces());

    var index = 0;
    final result = data.entries
        .map((entry) => _NetworkInterface.fromJS(
            entry.key, index++, List<Map>.from(entry.value)))
        .toList(growable: false);

    return Future.value(result);
  }
}

class _NetworkInterface implements io.NetworkInterface {
  @override
  final List<io.InternetAddress> addresses;

  @override
  final int index;

  @override
  final String name;

  factory _NetworkInterface.fromJS(String name, int index, List<Map> data) {
    final addresses = data
        .map((Map addr) => addr['address'] as String)
        .map((ip) => InternetAddress(ip))
        .toList(growable: false);
    return _NetworkInterface(addresses, index, name);
  }

  _NetworkInterface(this.addresses, this.index, this.name);

  @override
  String toString() {
    return 'NetworkInterface #$index($name, $addresses)';
  }
}
