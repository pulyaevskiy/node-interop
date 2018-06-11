// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:js';
import 'dart:js_util';

import 'package:node_interop/http.dart' as _http;

import 'http_headers.dart';
import 'internet_address.dart';
import 'streams.dart';

export 'dart:io'
    show
        HttpStatus,
        HttpHeaders,
        ContentType,
        Cookie,
        HttpException,
        HttpRequest,
        HttpResponse;

class _HttpConnectionInfo implements io.HttpConnectionInfo {
  @override
  final int localPort;

  @override
  final InternetAddress remoteAddress;

  @override
  final int remotePort;

  _HttpConnectionInfo(this.localPort, this.remoteAddress, this.remotePort);
}

abstract class HttpServer implements io.HttpServer {
  static Future<io.HttpServer> bind(address, int port,
          {int backlog: 0, bool v6Only: false, bool shared: false}) =>
      _HttpServer.bind(address, port,
          backlog: backlog, v6Only: v6Only, shared: shared);
}

class _HttpServer extends Stream<io.HttpRequest> implements HttpServer {
  @override
  final io.InternetAddress address;
  @override
  final int port;

  _http.HttpServer _server;
  Completer<io.HttpServer> _listenCompleter;
  StreamController<io.HttpRequest> _controller;

  _HttpServer._(this.address, this.port) {
    _controller = new StreamController<io.HttpRequest>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel,
    );
    _server = _http.http.createServer(allowInterop(_jsRequestHandler));
    _server.on('error', allowInterop(_jsErrorHandler));
  }

  void _onListen() {}
  void _onPause() {}
  void _onResume() {}
  void _onCancel() {
    _server.close();
  }

  void _jsErrorHandler(error) {
    if (_listenCompleter != null) {
      _listenCompleter.completeError(error);
      _listenCompleter = null;
    }
    _controller.addError(error);
  }

  void _jsRequestHandler(
      _http.IncomingMessage request, _http.ServerResponse response) {
    if (_controller.isPaused) {
      // Reject any incoming request before listening started or subscription
      // is paused.
      response.statusCode = io.HttpStatus.serviceUnavailable;
      response.end();
      return;
    }
    _controller.add(new NodeHttpRequest(request, response));
  }

  Future<io.HttpServer> _bind() {
    assert(_server.listening == false && _listenCompleter == null);

    _listenCompleter = new Completer<io.HttpServer>();
    void listeningHandler() {
      _listenCompleter.complete(this);
      _listenCompleter = null;
    }

    _server.listen(port, address.address, null, allowInterop(listeningHandler));
    return _listenCompleter.future;
  }

  static Future<io.HttpServer> bind(address, int port,
      {int backlog: 0, bool v6Only: false, bool shared: false}) async {
    assert(!shared, 'Shared is not implemented yet');

    if (address is String) {
      List<InternetAddress> list = await InternetAddress.lookup(address);
      address = list.first;
    }
    var server = new _HttpServer._(address, port);
    return server._bind();
  }

  @override
  bool autoCompress; // TODO: Implement autoCompress

  @override
  Duration idleTimeout; // TODO: Implement idleTimeout

  @override
  String serverHeader; // TODO: Implement serverHeader

  @override
  Future<Null> close({bool force: false}) {
    assert(!force, 'Force argument is not supported by Node HTTP server');
    final Completer<Null> completer = new Completer<Null>();
    _server.close(allowInterop(([error]) {
      _controller.close();
      if (error != null) {
        completer.complete(error);
      } else
        completer.complete();
    }));
    return completer.future;
  }

  @override
  io.HttpConnectionsInfo connectionsInfo() {
    throw new UnimplementedError();
  }

  @override
  io.HttpHeaders get defaultResponseHeaders => throw new UnimplementedError();

  @override
  StreamSubscription<io.HttpRequest> listen(void onData(io.HttpRequest event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  set sessionTimeout(int timeout) {
    throw new UnimplementedError();
  }
}

/// Server side HTTP request object which delegates IO operations to
/// Node's native representations.
class NodeHttpRequest extends ReadableStream<List<int>>
    implements io.HttpRequest {
  final _http.ServerResponse _nativeResponse;

  NodeHttpRequest(_http.IncomingMessage nativeRequest, this._nativeResponse)
      : super(nativeRequest, convert: (chunk) => new List.unmodifiable(chunk));

  _http.IncomingMessage get nativeInstance => super.nativeInstance;

  @override
  io.X509Certificate get certificate => throw new UnimplementedError();

  @override
  io.HttpConnectionInfo get connectionInfo {
    var socket = nativeInstance.socket;
    var address = new InternetAddress(socket.remoteAddress);
    return new _HttpConnectionInfo(
        socket.localPort, address, socket.remotePort);
  }

  @override
  int get contentLength => headers.contentLength;

  @override
  List<io.Cookie> get cookies {
    if (_cookies != null) return _cookies;
    _cookies = new List<io.Cookie>();
    List<String> values = headers[io.HttpHeaders.setCookieHeader];
    if (values != null) {
      values.forEach((value) {
        _cookies.add(new io.Cookie.fromSetCookieValue(value));
      });
    }
    return _cookies;
  }

  List<io.Cookie> _cookies;

  @override
  io.HttpHeaders get headers =>
      _headers ??= new RequestHttpHeaders(nativeInstance);
  io.HttpHeaders _headers;

  @override
  String get method => nativeInstance.method;

  @override
  bool get persistentConnection => headers.persistentConnection;

  @override
  String get protocolVersion => nativeInstance.httpVersion;

  @override
  Uri get requestedUri {
    if (_requestedUri == null) {
      var socket = nativeInstance.socket;

      var proto = headers['x-forwarded-proto'];
      var scheme;
      if (proto != null) {
        scheme = proto.first;
      } else {
        var isSecure = getProperty(socket, 'encrypted') ?? false;
        scheme = isSecure ? "https" : "http";
      }
      var hostList = headers['x-forwarded-host'];
      String host;
      if (hostList != null) {
        host = hostList.first;
      } else {
        hostList = headers['host'];
        if (hostList != null) {
          host = hostList.first;
        } else {
          host = "${socket.localAddress}:${socket.localPort}";
        }
      }
      _requestedUri = Uri.parse("$scheme://$host$uri");
    }
    return _requestedUri;
  }

  Uri _requestedUri;

  @override
  io.HttpResponse get response =>
      _response ??= new NodeHttpResponse(_nativeResponse);
  io.HttpResponse _response; // ignore: close_sinks

  @override
  io.HttpSession get session => throw new UnsupportedError(
      'Sessions are not supported by Node HTTP server.');

  @override
  Uri get uri => Uri.parse(nativeInstance.url);
}

class NodeHttpResponse extends NodeIOSink implements io.HttpResponse {
  NodeHttpResponse(_http.ServerResponse nativeResponse) : super(nativeResponse);

  _http.ServerResponse get nativeInstance => super.nativeInstance;

  @override
  bool get bufferOutput => throw new UnimplementedError();

  @override
  set bufferOutput(bool buffer) {
    throw new UnimplementedError();
  }

  @override
  int get contentLength => throw new UnimplementedError();

  @override
  set contentLength(int length) {
    throw new UnimplementedError();
  }

  @override
  Duration get deadline => throw new UnimplementedError();

  @override
  set deadline(Duration value) {
    throw new UnimplementedError();
  }

  @override
  bool get persistentConnection => headers.persistentConnection;

  @override
  set persistentConnection(bool persistent) {
    headers.persistentConnection = persistent;
  }

  @override
  String get reasonPhrase => nativeInstance.statusMessage;
  set reasonPhrase(String phrase) {
    if (nativeInstance.headersSent)
      throw new StateError('Headers already sent.');
    nativeInstance.statusMessage = phrase;
  }

  @override
  int get statusCode => nativeInstance.statusCode;

  @override
  set statusCode(int code) {
    if (nativeInstance.headersSent)
      throw new StateError('Headers already sent.');
    nativeInstance.statusCode = code;
  }

  @override
  Future close() {
    ResponseHttpHeaders responseHeaders = headers;
    responseHeaders.finalize();
    return super.close();
  }

  @override
  io.HttpConnectionInfo get connectionInfo {
    var socket = nativeInstance.socket;
    var address = new InternetAddress(socket.remoteAddress);
    return new _HttpConnectionInfo(
        socket.localPort, address, socket.remotePort);
  }

  @override
  List<io.Cookie> get cookies {
    if (_cookies != null) return _cookies;
    _cookies = new List<io.Cookie>();
    List<String> values = headers[io.HttpHeaders.setCookieHeader];
    if (values != null) {
      values.forEach((value) {
        _cookies.add(new io.Cookie.fromSetCookieValue(value));
      });
    }
    return _cookies;
  }

  List<io.Cookie> _cookies;

  @override
  Future<io.Socket> detachSocket({bool writeHeaders: true}) {
    throw new UnimplementedError();
  }

  @override
  io.HttpHeaders get headers =>
      _headers ??= new ResponseHttpHeaders(nativeInstance);
  ResponseHttpHeaders _headers;

  @override
  Future redirect(Uri location, {int status: io.HttpStatus.movedTemporarily}) {
    statusCode = status;
    headers.set("location", location);
    return close();
  }
}
