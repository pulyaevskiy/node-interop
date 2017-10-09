// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:js/js.dart';

import 'bindings/globals.dart';
import 'bindings/http.dart' as nodeHTTP;
import 'internet_address.dart';

export 'dart:io' show HttpStatus, HttpHeaders;

final nodeHTTP.HTTP _http = require('http');

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

class HttpRequest extends Stream<List<int>> implements io.HttpRequest {
  final nodeHTTP.IncomingMessage _nativeRequest;
  final nodeHTTP.ServerResponse _nativeResponse;

  HttpRequest._(this._nativeRequest, this._nativeResponse);

  @override
  io.X509Certificate get certificate => throw new UnimplementedError();

  @override
  io.HttpConnectionInfo get connectionInfo => throw new UnimplementedError();

  @override
  int get contentLength => throw new UnimplementedError();

  @override
  List<io.Cookie> get cookies => throw new UnimplementedError();

  @override
  io.HttpHeaders get headers => throw new UnimplementedError();

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> event),
      {Function onError, void onDone(), bool cancelOnError}) {
    throw new UnimplementedError();
  }

  @override
  String get method => _nativeRequest.method;

  @override
  bool get persistentConnection => throw new UnimplementedError();

  @override
  String get protocolVersion => _nativeRequest.httpVersion;

  @override
  Uri get requestedUri => throw new UnimplementedError();

  @override
  io.HttpResponse get response =>
      _response ??= new HttpResponse._(_nativeResponse);
  io.HttpResponse _response;

  // TODO: implement session
  @override
  io.HttpSession get session => throw new UnsupportedError(
      'Sessions are not supported by Node HTTP server.');

  @override
  Uri get uri => Uri.parse(_nativeRequest.url);
}

class HttpResponse extends io.HttpResponse {
  final nodeHTTP.ServerResponse _nativeResponse;

  @override
  Encoding encoding;

  HttpResponse._(this._nativeResponse);

  @override
  void add(List<int> data) {
    throw new UnimplementedError();
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    throw new UnimplementedError();
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    throw new UnimplementedError();
  }

  @override
  Future close() {
    _nativeResponse.end();
    return new Future.value();
  }

  @override
  io.HttpConnectionInfo get connectionInfo => throw new UnimplementedError();

  @override
  List<io.Cookie> get cookies => throw new UnimplementedError();

  @override
  Future<io.Socket> detachSocket({bool writeHeaders: true}) {
    throw new UnimplementedError();
  }

  @override
  Future get done => throw new UnimplementedError();

  @override
  Future flush() {
    throw new UnimplementedError();
  }

  @override
  io.HttpHeaders get headers => throw new UnimplementedError();

  @override
  Future redirect(Uri location, {int status: io.HttpStatus.MOVED_TEMPORARILY}) {
    throw new UnimplementedError();
  }

  @override
  void write(Object obj) {
    throw new UnimplementedError();
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    throw new UnimplementedError();
  }

  @override
  void writeCharCode(int charCode) {
    throw new UnimplementedError();
  }

  @override
  void writeln([Object obj = ""]) {
    // TODO: implement writeln
  }
}
