// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node HTTPS module bindings.
///
/// Use top-level [https] object to access this module functionality.
/// To create HTTPS agent use [createHttpsAgent].
@JS()
library node_interop.https;

import 'dart:js_util';

import 'package:js/js.dart';

import 'node.dart';
import 'http.dart';
import 'tls.dart';

export 'http.dart'
    show
        HttpAgent,
        HttpAgentOptions,
        ClientRequest,
        IncomingMessage,
        ServerResponse;

HTTPS get https => require('https');

/// Convenience method for creating instances of "https" module's Agent class.
///
/// This is equivalent of Node's `new https.Agent([options])`.
HttpAgent createHttpsAgent([HttpAgentOptions options]) {
  var args = (options == null) ? [] : [options];
  return callConstructor(https.Agent, args);
}

@JS()
@anonymous
abstract class HTTPS {
  /// Returns a new instance of [HttpsServer].
  ///
  /// The requestListener is a function which is automatically added to the
  /// 'request' event.
  external HttpsServer createServer(
      [TlsServerOptions options, HttpRequestListener requestListener]);
  external ClientRequest request(RequestOptions options,
      [callback(IncomingMessage response)]);

  /// Makes GET request. The only difference between this method and
  /// [request] is that it sets the method to GET and calls req.end()
  /// automatically.
  external ClientRequest get(dynamic urlOrOptions,
      [callback(IncomingMessage response)]);

  external HttpAgent get globalAgent;
  external dynamic get Agent;
}

@JS()
@anonymous
abstract class HttpsServer extends TlsServer implements HttpServer {}
