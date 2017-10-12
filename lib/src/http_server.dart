// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:js/js.dart';

import 'bindings/globals.dart';
import 'bindings/http.dart' as nodeHTTP;
import 'internet_address.dart';
import 'package:js/js_util.dart';
import 'util.dart';

export 'dart:io' show HttpStatus, HttpHeaders, ContentType;

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

class _HttpConnectionInfo implements io.HttpConnectionInfo {
  @override
  final int localPort;

  @override
  final InternetAddress remoteAddress;

  @override
  final int remotePort;

  _HttpConnectionInfo(this.localPort, this.remoteAddress, this.remotePort);
}

/// HTTP headers which can not be modified.
///
/// All mutation methods of this class throw [UnsupportedError].
class ImmutableHttpHeaders implements io.HttpHeaders {
  final int _port;
  final dynamic _headers;

  ImmutableHttpHeaders(this._headers, this._port);

  @override
  bool get chunkedTransferEncoding =>
      getProperty(_headers, io.HttpHeaders.TRANSFER_ENCODING) == 'chunked';

  @override
  void set chunkedTransferEncoding(bool chunked) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  int get contentLength {
    var value = getProperty(_headers, io.HttpHeaders.CONTENT_LENGTH);
    if (value != null) return int.parse(value);
    return 0;
  }

  @override
  set contentLength(int length) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  io.ContentType get contentType {
    if (_contentType != null) return _contentType;
    String value = getProperty(_headers, io.HttpHeaders.CONTENT_TYPE);
    if (value == null || value.isEmpty) return null;
    var types = value.split(',');
    _contentType = io.ContentType.parse(types.first);
    return _contentType;
  }

  io.ContentType _contentType;

  @override
  set contentType(io.ContentType type) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  DateTime get date {
    String value = getProperty(_headers, io.HttpHeaders.DATE);
    if (value == null || value.isEmpty) return null;
    try {
      return io.HttpDate.parse(value);
    } on Exception catch (e) {
      return null;
    }
  }

  @override
  set date(DateTime date) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  DateTime get expires {
    String value = getProperty(_headers, io.HttpHeaders.EXPIRES);
    if (value == null || value.isEmpty) return null;
    try {
      return io.HttpDate.parse(value);
    } on Exception catch (e) {
      return null;
    }
  }

  @override
  set expires(DateTime expires) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  String get host => getProperty(_headers, io.HttpHeaders.HOST);

  @override
  set host(String host) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  DateTime get ifModifiedSince {
    String value = getProperty(_headers, io.HttpHeaders.IF_MODIFIED_SINCE);
    if (value == null || value.isEmpty) return null;
    try {
      return io.HttpDate.parse(value);
    } on Exception catch (e) {
      return null;
    }
  }

  @override
  set ifModifiedSince(DateTime ifModifiedSince) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  bool get persistentConnection {
    var connection = getProperty(_headers, io.HttpHeaders.CONNECTION);
    return (connection == 'keep-alive');
  }

  @override
  set persistentConnection(bool persistentConnection) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  List<String> operator [](String name) {
    throw new UnimplementedError();
  }

  @override
  void add(String name, Object value) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  void clear() {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  void forEach(void f(String name, List<String> values)) {
    throw new UnimplementedError();
  }

  @override
  void noFolding(String name) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  void remove(String name, Object value) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  void removeAll(String name) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  void set(String name, Object value) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  String value(String name) {
    throw new UnimplementedError();
  }

  @override
  set port(int port) {
    throw new UnsupportedError('HttpHeaders are immutable');
  }

  @override
  int get port => _port;
}

class HttpRequest extends Stream<List<int>> implements io.HttpRequest {
  final nodeHTTP.IncomingMessage _nativeRequest;
  final nodeHTTP.ServerResponse _nativeResponse;

  HttpRequest._(this._nativeRequest, this._nativeResponse);

  @override
  io.X509Certificate get certificate => throw new UnimplementedError();

  @override
  io.HttpConnectionInfo get connectionInfo {
    var netAddress = _nativeRequest.socket.address();
    var address = new InternetAddress(netAddress.address, null);
    return new _HttpConnectionInfo(netAddress.port, address, null);
  }

  @override
  int get contentLength => headers.contentLength;

  @override
  List<io.Cookie> get cookies => throw new UnimplementedError();

  @override
  io.HttpHeaders get headers => new ImmutableHttpHeaders(
      _nativeRequest.headers, connectionInfo.remotePort);

  StreamController<List<int>> _controller;
  @override
  StreamSubscription<List<int>> listen(void onData(List<int> event),
      {Function onError, void onDone(), bool cancelOnError}) {
    assert(_controller == null);
    _controller = new StreamController();

    _nativeRequest.on('close', allowInterop(() {
      _controller.close();
    }));
    _nativeRequest.on('data', allowInterop((Iterable<int> chunk) {
      _controller.add(new List.unmodifiable(chunk));
    }));
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  String get method => _nativeRequest.method;

  @override
  bool get persistentConnection => headers.persistentConnection;

  @override
  String get protocolVersion => _nativeRequest.httpVersion;

  @override
  Uri get requestedUri => throw new UnimplementedError();

  @override
  io.HttpResponse get response =>
      _response ??= new HttpResponse._(_nativeResponse);
  io.HttpResponse _response;

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
