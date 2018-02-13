// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js Net module.
///
/// Use library-level [net] object to access this module functionality.
@JS()
library node_interop.net;

import 'package:js/js.dart';
import 'events.dart';
import 'node.dart';

Net get net => _net ??= require('net');
Net _net;

@JS()
@anonymous
abstract class Net {
  external num isIP(String input);
  external bool isIPv4(String input);
  external bool isIPv6(String input);
}

@JS()
abstract class Socket extends EventEmitter {
  external NetAddress address();
  external String get remoteAddress;
  external String get remoteFamily;
  external int get remotePort;
  external String get localAddress;
  external String get localFamily;
  external int get localPort;
}

@JS()
abstract class NetAddress {
  external int get port;
  external String get family;
  external String get address;
}

@JS()
abstract class NetServer {}
