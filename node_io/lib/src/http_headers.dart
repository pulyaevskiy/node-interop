// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:io' as io;

import 'package:js/js_util.dart';
import 'package:node_interop/http.dart';
import 'package:node_interop/js.dart';

/// List of HTTP header names which can only have single value.
const _singleValueHttpHeaders = const [
  'age',
  'authorization',
  'content-length',
  'content-type',
  'date',
  'etag',
  'expires',
  'from',
  'host',
  'if-modified-since',
  'if-unmodified-since',
  'last-modified',
  'location',
  'max-forwards',
  'proxy-authorization',
  'referer',
  'retry-after',
  'user-agent',
];

class ResponseHttpHeaders extends HttpHeaders {
  @override
  final ServerResponse nativeResponse;

  ResponseHttpHeaders(this.nativeResponse);

  @override
  get nativeHeaders => nativeResponse.getHeaders();
}

class RequestHttpHeaders extends HttpHeaders {
  final IncomingMessage _request;

  RequestHttpHeaders(this._request);

  @override
  get nativeHeaders => _request.headers;
}

/// Proxy to native JavaScript HTTP headers.
abstract class HttpHeaders implements io.HttpHeaders {
  bool _mutable = true;

  dynamic get nativeHeaders;
  ServerResponse get nativeResponse => null;

  void _checkMutable() {
    if (nativeResponse == null || _mutable == false)
      throw new io.HttpException('HTTP headers are not mutable.');
  }

  void finalize() {
    _mutable = false;
  }

  dynamic getHeader(String name) => getProperty(nativeHeaders, name);

  @override
  bool get chunkedTransferEncoding =>
      getHeader(io.HttpHeaders.TRANSFER_ENCODING) == 'chunked';

  @override
  void set chunkedTransferEncoding(bool chunked) {
    _checkMutable();
    if (chunked) {
      nativeResponse.setHeader(io.HttpHeaders.TRANSFER_ENCODING, value);
    } else {
      nativeResponse.removeHeader(io.HttpHeaders.TRANSFER_ENCODING);
    }
  }

  @override
  int get contentLength {
    var value = getHeader(io.HttpHeaders.CONTENT_LENGTH);
    if (value != null) return int.parse(value);
    return 0;
  }

  @override
  set contentLength(int length) {
    _checkMutable();
    nativeResponse.setHeader(io.HttpHeaders.CONTENT_LENGTH, length);
  }

  @override
  io.ContentType get contentType {
    if (_contentType != null) return _contentType;
    String value = getHeader(io.HttpHeaders.CONTENT_TYPE);
    if (value == null || value.isEmpty) return null;
    var types = value.split(',');
    _contentType = io.ContentType.parse(types.first);
    return _contentType;
  }

  io.ContentType _contentType;

  @override
  set contentType(io.ContentType type) {
    _checkMutable();
    nativeResponse.setHeader(io.HttpHeaders.CONTENT_TYPE, type.toString());
  }

  @override
  DateTime get date {
    String value = getHeader(io.HttpHeaders.DATE);
    if (value == null || value.isEmpty) return null;
    try {
      return io.HttpDate.parse(value);
    } on Exception {
      return null;
    }
  }

  @override
  set date(DateTime date) {
    _checkMutable();
    nativeResponse.setHeader(io.HttpHeaders.DATE, io.HttpDate.format(date));
  }

  @override
  DateTime get expires {
    String value = getHeader(io.HttpHeaders.EXPIRES);
    if (value == null || value.isEmpty) return null;
    try {
      return io.HttpDate.parse(value);
    } on Exception {
      return null;
    }
  }

  @override
  set expires(DateTime expires) {
    _checkMutable();
    nativeResponse.setHeader(
        io.HttpHeaders.EXPIRES, io.HttpDate.format(expires));
  }

  @override
  String get host {
    String value = getHeader(io.HttpHeaders.HOST);
    if (value != null) {
      return value.split(':').first;
    }
    return null;
  }

  @override
  set host(String host) {
    _checkMutable();
    var hostAndPort = host;
    int _port = this.port;
    if (_port != null) {
      hostAndPort = "$host:$_port";
    }
    nativeResponse.setHeader(io.HttpHeaders.HOST, hostAndPort);
  }

  @override
  int get port {
    String value = getHeader(io.HttpHeaders.HOST);
    if (value != null) {
      var parts = value.split(':');
      if (parts.length == 2) return int.parse(parts.last);
    }
    return null;
  }

  @override
  set port(int value) {
    _checkMutable();
    var hostAndPort = host;
    if (value != null) {
      hostAndPort = "$host:$value";
    }
    nativeResponse.setHeader(io.HttpHeaders.HOST, hostAndPort);
  }

  @override
  DateTime get ifModifiedSince {
    String value = getHeader(io.HttpHeaders.IF_MODIFIED_SINCE);
    if (value == null || value.isEmpty) return null;
    try {
      return io.HttpDate.parse(value);
    } on Exception {
      return null;
    }
  }

  @override
  set ifModifiedSince(DateTime ifModifiedSince) {
    _checkMutable();
    nativeResponse.setHeader(
        io.HttpHeaders.IF_MODIFIED_SINCE, io.HttpDate.format(ifModifiedSince));
  }

  @override
  bool get persistentConnection {
    var connection = getHeader(io.HttpHeaders.CONNECTION);
    return (connection == 'keep-alive');
  }

  @override
  set persistentConnection(bool persistentConnection) {
    _checkMutable();
    var value = persistentConnection ? 'keep-alive' : 'close';
    nativeResponse.setHeader(io.HttpHeaders.CONNECTION, value);
  }

  bool _isMultiValue(String name) => !_singleValueHttpHeaders.contains(name);

  @override
  List<String> operator [](String name) {
    name = name.toLowerCase();
    var value = getHeader(name);
    if (value != null) {
      if (value is String) {
        return _isMultiValue(name) ? value.split(',') : [value];
      } else {
        // NodeJS treats `set-cookie` differently from other headers and
        // composes all values in an array.
        return new List.unmodifiable(value);
      }
    }
    return null;
  }

  @override
  String value(String name) {
    List<String> values = this[name];
    if (values == null) return null;
    if (values.length > 1) {
      throw new io.HttpException("More than one value for header $name");
    }
    return values[0];
  }

  @override
  void add(String name, Object value) {
    _checkMutable();
    List<String> existingValues = this[name];
    var values = existingValues != null ? new List.from(existingValues) : [];
    values.add(value.toString());
    nativeResponse.setHeader(name, values);
  }

  @override
  void clear() {
    _checkMutable();
    var names = nativeResponse.getHeaderNames();
    for (var name in names) {
      nativeResponse.removeHeader(name);
    }
  }

  // Get the list of header keys
  Iterable<String> _getHeaderNames() {
    return objectKeys(nativeHeaders);
  }

  @override
  void forEach(void f(String name, List<String> values)) {
    var names = _getHeaderNames();
    names.forEach((name) {
      f(name, this[name]);
    });
  }

  @override
  void noFolding(String name) {
    throw new UnsupportedError("Folding is not supported for Node.");
  }

  @override
  void remove(String name, Object value) {
    throw new UnsupportedError(
        "Removing individual values not supported for Node.");
  }

  @override
  void removeAll(String name) {
    _checkMutable();
    nativeResponse.removeHeader(name);
  }

  @override
  void set(String name, Object value) {
    _checkMutable();
    nativeResponse.setHeader(name, value.toString());
  }
}
