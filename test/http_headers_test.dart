// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
@TestOn('node')
library node_interop.http_headers_test;

import 'dart:async';
import 'dart:js';

import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';
import 'package:node_interop/test.dart';
import 'package:test/test.dart';
import 'package:node_interop/src/http_server.dart';

final HTTP nodeHTTP = require('http');

const headersJS = '''
exports.headers = {
  'transfer-encoding': 'chunked',
  'content-type': 'text/html; charset=utf-8',
  'date': 'Thu, 1 Jan 1970 00:00:00 GMT',
  'expires': 'Thu, 1 Jan 1970 01:15:00 GMT',
  'host': 'example.com',
  'if-modified-since': 'Thu, 1 Jan 1970 03:15:00 GMT',
  'connection': 'keep-alive'
};
exports.minimal = {
  'user-agent': 'curl/7.22.0'
};
''';

@JS()
abstract class HeadersFixture {
  external dynamic get headers;
  external dynamic get minimal;
}

void main() {
  createJSFile('headers.js', headersJS);

  group('ImmutableHttpHeaders', () {
    HeadersFixture jsHeaders = node.require('./headers.js');
    var headers = new ImmutableHttpHeaders(jsHeaders.headers, 80);
    var emptyHeaders = new ImmutableHttpHeaders(jsHeaders.minimal, 80);

    test('chunkedTransferEncoding', () async {
      expect(headers.chunkedTransferEncoding, isTrue);
      expect(emptyHeaders.chunkedTransferEncoding, isFalse);
    });

    test('contentType', () async {
      expect(headers.contentType, new isInstanceOf<ContentType>());
      expect(headers.contentType, same(headers.contentType));
      expect(emptyHeaders.contentType, isNull);
    });

    test('date', () async {
      expect(headers.date, new isInstanceOf<DateTime>());
      expect(emptyHeaders.date, isNull);
    });

    test('expires', () async {
      expect(headers.expires, new isInstanceOf<DateTime>());
      expect(emptyHeaders.expires, isNull);
    });

    test('host', () async {
      expect(headers.host, 'example.com');
      expect(emptyHeaders.host, isNull);
    });

    test('port', () {
      expect(headers.port, 80);
    });

    test('ifModifiedSince', () async {
      expect(headers.ifModifiedSince, new isInstanceOf<DateTime>());
      expect(emptyHeaders.ifModifiedSince, isNull);
    });


    test('persistentConnection', () async {
      expect(headers.persistentConnection, isTrue);
      expect(emptyHeaders.persistentConnection, isFalse);
    });
  });
}
