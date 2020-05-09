// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "net" module.
///
/// Use library-level [net] object to access this module functionality.
@JS()
library node_interop.net;

import 'package:js/js.dart';

import 'events.dart';
import 'node.dart';
import 'stream.dart';

Net get net => _net ??= require('net');
Net _net;

@JS()
@anonymous
abstract class Net {
  /// Alias to [createConnection].
  external Socket connect(arg1, [arg2, arg3]);

  /// See official documentation for possible signatures:
  /// - https://nodejs.org/api/net.html#net_net_createconnection
  external Socket createConnection(arg1, [arg2, arg3]);
  external Socket createServer([options, void Function() connectionListener]);
  external num isIP(String input);
  external bool isIPv4(String input);
  external bool isIPv6(String input);
}

@JS()
@anonymous
abstract class Socket implements Duplex, EventEmitter {
  external NetAddress address();
  external int get bufferSize;
  external int get bytesRead;
  external int get bytesWritten;

  /// See official documentation on possible signatures:
  /// - https://nodejs.org/api/net.html#net_socket_connect
  external Socket connect(arg1, [arg2, arg3]);
  external bool get connecting;
  @override
  external Socket destroy([exception]);
  external bool get destroyed;
  @override
  external Socket end([data, encoding, unused]);
  external String get localAddress;
  external String get localFamily;
  external int get localPort;
  @override
  external Socket pause();
  external Socket ref();
  external String get remoteAddress;
  external String get remoteFamily;
  external int get remotePort;
  @override
  external Socket resume();
  @override
  external Socket setEncoding([encoding]);
  external Socket setKeepAlive([bool enable, initialDelay]);
  external Socket setNoDelay([bool noDelay]);
  external Socket setTimeout(timeout, [void Function() callback]);
  external Socket unref();
  @override
  external bool write(chunk, [encodingOrCallback, callback]);
}

@JS()
@anonymous
abstract class NetAddress {
  external int get port;
  external String get family;
  external String get address;
}

@JS()
@anonymous
abstract class NetServer implements EventEmitter {
  external NetAddress address();
  external NetServer close([void Function() callback]);
  external void getConnections(
      [void Function(dynamic error, int count) callback]);

  /// See official documentation on possible signatures:
  /// - https://nodejs.org/api/net.html#net_server_listen
  external void listen([arg1, arg2, arg3, arg4]);
  external bool get listening;
  external int get maxConnections;
  external NetServer ref();
  external NetServer unref();
}
