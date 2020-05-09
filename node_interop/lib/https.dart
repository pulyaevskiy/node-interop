// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "https" module bindings.
///
/// Use library-level [https] object to access this module functionality.
/// To create HTTPS agent use [createHttpsAgent].
@JS()
library node_interop.https;

import 'dart:js_util';

import 'package:js/js.dart';

import 'http.dart';
import 'node.dart';
import 'tls.dart';

export 'http.dart'
    show
        HttpAgent,
        HttpAgentOptions,
        ClientRequest,
        IncomingMessage,
        ServerResponse;

HTTPS get https => _https ??= require('https');
HTTPS _https;

/// Convenience method for creating instances of "https" module's Agent class.
///
/// This is equivalent of Node's `new https.Agent([options])`.
HttpsAgent createHttpsAgent([HttpsAgentOptions options]) {
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
      [TLSServerOptions options, HttpRequestListener requestListener]);

  /// Makes GET request. The only difference between this method and
  /// [request] is that it sets the method to GET and calls req.end()
  /// automatically.
  external ClientRequest get(dynamic urlOrOptions,
      [void Function(IncomingMessage response) callback]);

  /// Makes a request to a secure web server.
  external ClientRequest request(RequestOptions options,
      [void Function(IncomingMessage response) callback]);

  /// Global instance of [HttpsAgent] for all HTTPS client requests.
  external HttpAgent get globalAgent;

  /// Reference to constructor function of [HttpsAgent] class.
  ///
  /// See also:
  /// - [createHttpsAgent].
  external Function get Agent;
}

@JS()
@anonymous
abstract class HttpsAgent implements HttpAgent {}

@JS()
@anonymous
abstract class HttpsServer implements TLSServer, HttpServer {
  external HttpsServer close([void Function() callback]);
  @override
  external void listen([arg1, arg2, arg3, arg4]);
  @override
  external void setTimeout([num msecs, void Function() callback]);
  @override
  external num get timeout;
  @override
  external num get keepAliveTimeout;
}

@JS()
@anonymous
abstract class HttpsAgentOptions {
  external bool get keepAlive;
  external num get keepAliveMsecs;
  external num get maxSockets;
  external num get maxFreeSockets;

  /// Optionally override the trusted CA certificates.
  ///
  /// Default is to trust the well-known CAs curated by Mozilla.
  external dynamic get ca;

  /// Cert chains in PEM format.
  external dynamic get cert;

  /// Cipher suite specification, replacing the default.
  external String get ciphers;

  /// Name of an OpenSSL engine which can provide the client certificate.
  external String get clientCertEngine;

  /// PEM formatted CRLs (Certificate Revocation Lists).
  external dynamic get crl;

  /// Private keys in PEM format.
  external dynamic get key;

  /// Shared passphrase used for a single private key and/or a PFX.
  external String get passphrase;

  /// PFX or PKCS12 encoded private key and certificate chain.
  ///
  /// An alternative to providing key and cert individually.
  external dynamic get pfx;

  /// SSL method to use.
  ///
  /// For example, 'TLSv1_2_method' to force TLS version 1.2. Default: 'TLS_method'.
  /// Possible values listed here: https://www.openssl.org/docs/man1.1.0/ssl/ssl.html#Dealing-with-Protocol-Methods
  external String get secureProtocol;
  external factory HttpsAgentOptions({
    bool keepAlive,
    num keepAliveMsecs,
    num maxSockets,
    num maxFreeSockets,
    dynamic ca,
    dynamic cert,
    String ciphers,
    String clientCertEngine,
    dynamic crl,
    dynamic key,
    String passphrase,
    dynamic pfx,
    String secureProtocol,
  });
}
