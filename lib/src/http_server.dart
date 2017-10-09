// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:js/js.dart';

import 'bindings/globals.dart';
import 'bindings/http.dart';
import 'internet_address.dart';

export 'dart:io' show HttpStatus, HttpHeaders;

final HTTP _nodeHTTP = require('http');

class HttpServer extends Stream<io.HttpRequest> implements io.HttpServer {
  @override
  final InternetAddress address;
  @override
  final int port;

  Server _server;
  Completer<HttpServer> _listenCompleter;
  StreamController<io.HttpRequest> _controller;

  HttpServer._(this.address, this.port) {
    _controller = new StreamController<io.HttpRequest>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel,
    );
    _server = _nodeHTTP.createServer(allowInterop(_jsRequestHandler));
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

  void _jsRequestHandler(IncomingMessage request, ServerResponse response) {
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
  final IncomingMessage _nativeRequest;
  final ServerResponse _nativeResponse;

  HttpRequest._(this._nativeRequest, this._nativeResponse);

  // TODO: implement certificate
  @override
  io.X509Certificate get certificate => null;

  // TODO: implement connectionInfo
  @override
  io.HttpConnectionInfo get connectionInfo => null;

  // TODO: implement contentLength
  @override
  int get contentLength => null;

  // TODO: implement cookies
  @override
  List<io.Cookie> get cookies => null;

  // TODO: implement headers
  @override
  io.HttpHeaders get headers => null;

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> event),
      {Function onError, void onDone(), bool cancelOnError}) {
    // TODO: implement listen
  }

  @override
  String get method => _nativeRequest.method;

  // TODO: implement persistentConnection
  @override
  bool get persistentConnection => throw new UnimplementedError();

  @override
  String get protocolVersion => _nativeRequest.httpVersion;

  // TODO: implement requestedUri
  @override
  Uri get requestedUri => null;

  // TODO: implement response
  @override
  io.HttpResponse get response => null;

  // TODO: implement session
  @override
  io.HttpSession get session => throw new UnsupportedError(
      'Sessions are not supported by Node HTTP server.');

  @override
  Uri get uri => Uri.parse(_nativeRequest.url);
}

class HttpResponse extends io.HttpResponse {
  final ServerResponse _nativeResponse;

  @override
  Encoding encoding;

  HttpResponse._(this._nativeResponse);

  @override
  void add(List<int> data) {
    // TODO: implement add
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    // TODO: implement addError
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    // TODO: implement addStream
  }

  @override
  Future close() {
    _nativeResponse.end();
    return new Future.value();
  }

  // TODO: implement connectionInfo
  @override
  io.HttpConnectionInfo get connectionInfo => null;

  // TODO: implement cookies
  @override
  List<io.Cookie> get cookies => null;

  @override
  Future<io.Socket> detachSocket({bool writeHeaders: true}) {
    // TODO: implement detachSocket
  }

  // TODO: implement done
  @override
  Future get done => null;

  @override
  Future flush() {
    // TODO: implement flush
  }

  // TODO: implement headers
  @override
  io.HttpHeaders get headers => null;

  @override
  Future redirect(Uri location, {int status: io.HttpStatus.MOVED_TEMPORARILY}) {
    // TODO: implement redirect
  }

  @override
  void write(Object obj) {
    // TODO: implement write
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    // TODO: implement writeAll
  }

  @override
  void writeCharCode(int charCode) {
    // TODO: implement writeCharCode
  }

  @override
  void writeln([Object obj = ""]) {
    // TODO: implement writeln
  }
}
