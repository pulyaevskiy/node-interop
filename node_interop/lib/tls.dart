// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "tls" module bindings.
///
/// Use library-level [tls] object as entrypoint.
@JS()
library node_interop.tls;

import 'dart:js_util';

import 'package:js/js.dart';

import 'buffer.dart';
import 'net.dart';
import 'node.dart';
import 'stream.dart';

TLS get tls => _tls ??= require('tls');
TLS _tls;

@JS()
@anonymous
abstract class TLS {
  /// Reference to constructor function of [TLSSocket].
  Function get TLSSocket;

  external JsError checkServerIdentity(String host, TLSPeerCertificate cert);

  /// See official documentation on possible signatures:
  /// - https://nodejs.org/api/tls.html#tls_tls_connect_options_callback
  ///
  /// Returns instance of [TLSSocket].
  // Can not declare return type as [TLSSocket] because there is a getter with
  // the same name.
  external dynamic connect(arg1, [arg2, arg3, arg4]);
  external TLSSecureContext createSecureContext(options);
  external TLSServer createServer([options, Function secureConnectionListener]);
  external List<String> getCiphers();

  external String get DEFAULT_ECDH_CURVE;
}

TLSSocket createTLSSocket(Socket socket, TLSSocketOptions options) {
  return callConstructor(tls.TLSSocket, [options]);
}

@JS()
@anonymous
abstract class TLSServer implements NetServer {
  external void addContext(String hostname, context);
  @override
  external NetAddress address();
  @override
  external TLSServer close([void Function() callback]);
  external Buffer getTicketKeys();

  /// See official documentation on possible signatures:
  /// - https://nodejs.org/api/net.html#net_server_listen
  @override
  external void listen([arg1, arg2, arg3, arg4]);
  external void setTicketKeys(Buffer keys);
}

@JS()
@anonymous
abstract class TLSSocket implements Duplex {
  external NetAddress address();
  external dynamic get authorizationError;
  external bool get authorized;
  external void disableRenegotiation();
  external bool get encrypted;
  external TLSCipher getCipher();
  external TLSEphemeralKeyInfo getEphemeralKeyInfo();
  external TLSPeerCertificate getPeerCertificate([bool detailed]);
  external String getProtocol();
  external dynamic getSession();
  external dynamic getTLSTicket();
  external String get localAddress;
  external num get localPort;
  external String get remoteAddress;
  external String get remoteFamily;
  external num get remotePort;
  external void renegotiate(options, Function callback);
  external void setMaxSendFragment(num size);
}

@JS()
@anonymous
abstract class TLSCipher {
  external String get name;
  @deprecated
  external String get version;
}

@JS()
@anonymous
abstract class TLSEphemeralKeyInfo {
  external String get type;
  external String get name;
  external int get size;
}

@JS()
@anonymous
abstract class TLSPeerCertificate {
  external dynamic get subject;
  external dynamic get issuer;
  external dynamic get issuerCertificate;
  external dynamic get raw;
  external dynamic get valid_from;
  external dynamic get valid_to;
  external String get fingerprint;
  external String get serialNumber;
}

@JS()
@anonymous
abstract class TLSSocketOptions implements TLSSecureContextOptions {
  external factory TLSSocketOptions({
    bool isServer,
    NetServer server,
    bool requestCert,
    bool rejectUnauthorized,
    List NPNProtocols,
    List ALPNProtocols,
    Function SNICallback,
    Buffer session,
    bool requestOCSP,
    dynamic secureContext,
    pfx,
    key,
    String passphrase,
    cert,
    ca,
    String ciphers,
    bool honorCipherOrder,
    String ecdhCurve,
    String clientCertEngine,
    crl,
    dhparam,
    num secureOptions,
    String secureProtocol,
    String sessionIdContext,
  });
  external bool get isServer;
  external NetServer get server;
  external bool get requestCert;
  external bool get rejectUnauthorized;
  external List get NPNProtocols;
  external List get ALPNProtocols;
  external Function get SNICallback;
  external Buffer get session;
  external bool get requestOCSP;
  external dynamic get secureContext;
}

@JS()
@anonymous
abstract class TLSSecureContext {}

@JS()
@anonymous
abstract class TLSSecureContextOptions {
  external factory TLSSecureContextOptions({
    pfx,
    key,
    String passphrase,
    cert,
    ca,
    String ciphers,
    bool honorCipherOrder,
    String ecdhCurve,
    String clientCertEngine,
    crl,
    dhparam,
    num secureOptions,
    String secureProtocol,
    String sessionIdContext,
  });
  external dynamic get pfx;
  external dynamic get key;
  external String get passphrase;
  external dynamic get cert;
  external dynamic get ca;
  external String get ciphers;
  external bool get honorCipherOrder;
  external String get ecdhCurve;
  external String get clientCertEngine;
  external dynamic get crl;
  external dynamic get dhparam;
  external num get secureOptions;
  external String get secureProtocol;
  external String get sessionIdContext;
}

@JS()
@anonymous
abstract class TLSServerOptions implements TLSSecureContextOptions {
  external factory TLSServerOptions({
    String clientCertEngine,
    num handshakeTimeout,
    bool requestCert,
    bool rejectUnauthorized,
    List NPNProtocols,
    List ALPNProtocols,
    Function SNICallback,
    num sessionTimeout,
    Buffer ticketKeys,
    pfx,
    key,
    String passphrase,
    cert,
    ca,
    String ciphers,
    bool honorCipherOrder,
    String ecdhCurve,
    crl,
    dhparam,
    num secureOptions,
    String secureProtocol,
    String sessionIdContext,
  });
  @override
  external String get clientCertEngine;
  external num get handshakeTimeout;
  external bool get requestCert;
  external bool get rejectUnauthorized;
  external List get NPNProtocols;
  external List get ALPNProtocols;
  external Function get SNICallback;
  external num get sessionTimeout;
  external Buffer get ticketKeys;
}
