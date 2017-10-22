// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io' as io;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'bindings/globals.dart';
import 'bindings/http.dart' as nodeHTTP;
import 'http_headers.dart';
import 'internet_address.dart';
import 'streams.dart';

export 'dart:io'
    show HttpStatus, HttpHeaders, ContentType, Cookie, HttpException;

final nodeHTTP.HTTP _http = require('http');

class _HttpConnectionInfo implements io.HttpConnectionInfo {
  @override
  final int localPort;

  @override
  final InternetAddress remoteAddress;

  @override
  final int remotePort;

  _HttpConnectionInfo(this.localPort, this.remoteAddress, this.remotePort);
}

class HttpServer extends Stream<io.HttpRequest> implements io.HttpServer {
  @override
  final InternetAddress address;
  @override
  final int port;

  nodeHTTP.HttpServer _server;
  Completer<HttpServer> _listenCompleter;
  StreamController<io.HttpRequest> _controller;

  HttpServer._(this.address, this.port) {
    _controller = new StreamController<io.HttpRequest>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel,
    );
    _server = _http.createServer(allowInterop(_jsRequestHandler));
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
      nodeHTTP.IncomingMessage request, nodeHTTP.ServerResponse response) {
    if (!_controller.isPaused) {
      // Reject any incoming request before listening started or subscription
      // is paused.
      response.statusCode = io.HttpStatus.SERVICE_UNAVAILABLE;
      response.end();
    }
    _controller.add(new HttpRequest(request, response));
  }

  Future<HttpServer> _bind() {
    assert(_server.listening == false && _listenCompleter == null);

    _listenCompleter = new Completer<HttpServer>();
    void listeningHandler() {
      _listenCompleter.complete(this);
      _listenCompleter = null;
    }

    _server.listen(port, address.address, null, allowInterop(listeningHandler));
    return _listenCompleter.future;
  }

  static Future<HttpServer> bind(address, int port) {
    var server = new HttpServer._(address, port);
    return server._bind();
  }

  @override
  bool autoCompress;

  @override
  Duration idleTimeout;

  @override
  String serverHeader;

  @override
  Future close({bool force: false}) {
    throw new UnimplementedError();
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
class HttpRequest extends ReadableStream<List<int>> implements io.HttpRequest {
  final nodeHTTP.ServerResponse _nativeResponse;

  HttpRequest(nodeHTTP.IncomingMessage nativeRequest, this._nativeResponse)
      : super(nativeRequest, convert: (chunk) => new List.unmodifiable(chunk));

  nodeHTTP.IncomingMessage get nativeInstance => super.nativeInstance;

  @override
  io.X509Certificate get certificate => throw new UnimplementedError();

  @override
  io.HttpConnectionInfo get connectionInfo {
    var socket = nativeInstance.socket;
    var address = new InternetAddress(socket.remoteAddress, null);
    return new _HttpConnectionInfo(
        socket.localPort, address, socket.remotePort);
  }

  @override
  int get contentLength => headers.contentLength;

  @override
  List<io.Cookie> get cookies {
    if (_cookies != null) return _cookies;
    _cookies = new List<io.Cookie>();
    List<String> values = headers[io.HttpHeaders.SET_COOKIE];
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
      _response ??= new HttpResponse(_nativeResponse);
  io.HttpResponse _response; // ignore: close_sinks

  @override
  io.HttpSession get session => throw new UnsupportedError(
      'Sessions are not supported by Node HTTP server.');

  @override
  Uri get uri => Uri.parse(nativeInstance.url);
}

class HttpResponse extends NodeIOSink implements io.HttpResponse {
  HttpResponse(nodeHTTP.ServerResponse nativeResponse) : super(nativeResponse);

  nodeHTTP.ServerResponse get nativeInstance => super.nativeInstance;

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
    if (nativeInstance.headersSent) throw new StateError('Headers already sent.');
    nativeInstance.statusMessage = phrase;
  }

  @override
  int get statusCode => nativeInstance.statusCode;

  @override
  set statusCode(int code) {
    if (nativeInstance.headersSent) throw new StateError('Headers already sent.');
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
    var address = new InternetAddress(socket.remoteAddress, null);
    return new _HttpConnectionInfo(
        socket.localPort, address, socket.remotePort);
  }

  @override
  List<io.Cookie> get cookies {
    if (_cookies != null) return _cookies;
    _cookies = new List<io.Cookie>();
    List<String> values = headers[io.HttpHeaders.SET_COOKIE];
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
  Future redirect(Uri location, {int status: io.HttpStatus.MOVED_TEMPORARILY}) {
    statusCode = status;
    headers.set("location", location);
    return close();
  }
}
