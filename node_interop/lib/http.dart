// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "http" module bindings.
///
/// Use top-level [http] object to access this module functionality.
/// To create an HTTP agent see [createHttpAgent].
@JS()
library node_interop.http;

import 'dart:js_util';

import 'package:js/js.dart';

import 'net.dart';
import 'node.dart';
import 'stream.dart';

HTTP get http => _http ??= require('http');
HTTP _http;

/// Convenience method for creating instances of "http" module's Agent class.
///
/// This is equivalent of Node's `new http.Agent([options])`.
HttpAgent createHttpAgent([HttpAgentOptions options]) {
  var args = (options == null) ? [] : [options];
  return callConstructor(http.Agent, args);
}

/// Listener on HTTP requests of [HttpServer].
///
/// See also:
///   - [HTTP.createServer]
typedef HttpRequestListener = void Function(
    IncomingMessage request, ServerResponse response);

/// Main entry point to Node's "http" module functionality.
///
/// Usage:
///
///     HTTP http = require('http');
///     http.get("http://example.com");
///
/// See also:
/// - [createHttpAgent]
@JS()
@anonymous
abstract class HTTP {
  /// A list of the HTTP methods that are supported by the parser.
  external List<String> get METHODS;

  /// A collection of all the standard HTTP response status codes, and the short
  /// description of each. For example, `http.STATUS_CODES[404] === 'Not Found'`.
  external dynamic get STATUS_CODES;

  /// Returns a new instance of [HttpServer].
  ///
  /// The [requestListener] is a function which is automatically added to the
  /// "request" event.
  external HttpServer createServer([HttpRequestListener requestListener]);

  /// Makes GET request. The only difference between this method and
  /// [request] is that it sets the method to GET and calls req.end()
  /// automatically.
  external ClientRequest get(dynamic urlOrOptions,
      [void Function(IncomingMessage response) callback]);

  /// Global instance of Agent which is used as the default for all HTTP client
  /// requests.
  external HttpAgent get globalAgent;

  external ClientRequest request(RequestOptions options,
      [void Function(IncomingMessage response) callback]);

  /// Reference to constructor function of [HttpAgent] class.
  ///
  /// See also:
  /// - [createHttpAgent].
  external Function get Agent;
}

@JS()
@anonymous
abstract class HttpAgent {
  external Socket createConnection(options,
      [void Function(dynamic error, dynamic stream) callback]);
  external void keepSocketAlive(Socket socket);
  external void reuseSocket(Socket socket, ClientRequest request);
  external void destroy();
  external dynamic get freeSockets;
  external String getName(options);
  external num get maxFreeSockets;
  external num get maxSockets;
  external dynamic get requests;
  external dynamic get sockets;
}

@JS()
@anonymous
abstract class HttpAgentOptions {
  external bool get keepAlive;
  external num get keepAliveMsecs;
  external num get maxSockets;
  external num get maxFreeSockets;
  external factory HttpAgentOptions({
    bool keepAlive,
    num keepAliveMsecs,
    num maxSockets,
    num maxFreeSockets,
  });
}

@JS()
@anonymous
abstract class RequestOptions {
  external String get protocol;
  @Deprecated('Use "hostname" instead.')
  external String get host;
  external String get hostname;
  external num get family;
  external num get port;
  external String get localAddress;
  external String get socketPath;
  external String get method;
  external String get path;
  external dynamic get headers;
  external String get auth;
  external dynamic get agent;
  external num get timeout;

  external factory RequestOptions({
    String protocol,
    String host,
    String hostname,
    num family,
    num port,
    String localAddress,
    String socketPath,
    String method,
    String path,
    dynamic headers,
    String auth,
    dynamic agent,
    num timeout,
  });
}

@JS()
abstract class ClientRequest implements Writable {
  external void abort();
  external int get aborted;
  external Socket get connection;
  @override
  external void end([data, encodingOrCallback, void Function() callback]);
  external void flushHeaders();
  external String getHeader(String name);
  external void removeHeader(String name);
  external void setHeader(String name, dynamic value);
  external void setNoDelay(bool noDelay);
  external void setSocketKeepAlive([bool enable, num initialDelay]);
  external void setTimeout(num msecs, [void Function() callback]);
  external Socket get socket;
  @override
  external ClientRequest write(chunk,
      [encodingOrCallback, void Function() callback]);
}

@JS()
abstract class HttpServer implements NetServer {
  @override
  external HttpServer close([void Function() callback]);
  @override
  external void listen([arg1, arg2, arg3, arg4]);
  @override
  external bool get listening;
  external num get maxHeadersCount;
  external void setTimeout([num msecs, void Function() callback]);
  external num get timeout;
  external num get keepAliveTimeout;
}

@JS()
@anonymous
abstract class ServerResponse implements Writable {
  external void addTrailers(headers);
  external Socket get connection;
  @override
  external void end([data, encodingOrCallback, void Function() callback]);
  external bool get finished;
  external dynamic getHeader(String name);
  external List<String> getHeaderNames();
  external dynamic getHeaders();
  external bool hasHeader(String name);
  external bool get headersSent;
  external void removeHeader(String name);
  external bool get sendDate;
  external void setHeader(String name, dynamic value);
  external void setTimeout(num msecs, [callback]);
  external Socket get socket;
  external num get statusCode;
  external set statusCode(num value);
  external String get statusMessage;
  external set statusMessage(String value);
  @override
  external bool write(chunk, [encodingOrCallback, void Function() callback]);
  external void writeContinue();
  external void writeHead(num statusCode, [String statusMessage, headers]);
}

@JS()
@anonymous
abstract class IncomingMessage implements Readable {
  @override
  external void destroy([error]);
  external dynamic get headers;
  external String get httpVersion;
  external String get method;
  external List<String> get rawHeaders;
  external List<String> get rawTrailers;
  external void setTimeout(num msecs, void Function() callback);
  external Socket get socket;
  external num get statusCode;
  external String get statusMessage;
  external dynamic get trailers;
  external String get url;
}
