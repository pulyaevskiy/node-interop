// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.http;

import 'dart:js';
import 'package:js/js.dart';
import 'events.dart';

@JS()
abstract class HTTP {
  /// Returns a new instance of [Server].
  ///
  /// The requestListener is a function which is automatically added to the
  /// 'request' event.
  external Server createServer([requestListener]);
  external ClientRequest request(options, [callback]);
  /// Makes GET request. The only difference between this method and
  /// [request] is that it sets the method to GET and calls req.end()
  /// automatically.
  external ClientRequest get(options, [callback(IncomingMessage response)]);
}

@JS()
abstract class ClientRequest implements EventEmitter {
  external void abort();
  external bool get aborted;
  external JsObject get connection; // TODO: Add net.Socket bindings
  external void end([dynamic data, String encoding, callback]);
  external void flushHeaders();
  external String getHeader(String name);
  external void removeHeader(String name);
  external void setHeader(String name, dynamic value);
  external void setNoDelay(bool noDelay);
  external void setSocketKeepAlive([bool enable, num initialDelay]);
  external void setTimeout(num msecs, [callback]);
  external JsObject get socket; // TODO: Add net.Socket bindings
  external void write(chunk,
      [String encoding, callback]); // TODO: Add Buffer bindings
}

@JS()
abstract class Server implements EventEmitter {
  external void close([callback]);
  external void listen(handleOrPathOrPort,
      [callbackOrHostname, backlog, callback]);
  external bool get listening;
  external num get maxHeadersCount;
  external void setTimeout([msecs, callback]);
  external num get timeout;
  external num get keepAliveTimeout;
}

@JS()
abstract class ServerResponse implements EventEmitter {
  external void addTrailers(headers);
  external JsObject get connection; // TODO: Add net.Socket bindings
  external void end([dynamic data, String encoding, callback]);
  external bool get finished;
  external String getHeader(String name);
  external JsArray<String> getHeaderNames();
  external JsObject getHeaders();
  external bool hasHeader(String name);
  external bool get headersSent;
  external void removeHeader(String name);
  external bool get sendDate;
  external void setHeader(String name, dynamic value);
  external void setTimeout(num msecs, [callback]);
  external JsObject get socket; // TODO: Add net.Socket bindings
  external num get statusCode;
  external void set statusCode(num value);
  external String get statusMessage;
  external void set statusMessage(String value);
  external void write(chunk,
      [String encoding, callback]); // TODO: Add Buffer bindings
  external void writeContinue();
  external void writeHead(num statusCode, [String statusMessage, headers]);
}

@JS()
abstract class IncomingMessage implements EventEmitter {
  external void destroy([error]);
  external JsObject get headers;
  external String get httpVersion;
  external String get method;
  external JsArray<String> get rawHeaders;
  external JsArray<String> get rawTrailers;
  external void setTimeout(num msecs, callback);
  external JsObject get socket; // TODO: Add net.Socket bindings
  external num get statusCode;
  external String get statusMessage;
  external JsObject get trailers;
  external String get url;
}
