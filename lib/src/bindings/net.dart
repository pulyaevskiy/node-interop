// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.net;

import 'package:js/js.dart';
import 'events.dart';

@JS()
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
