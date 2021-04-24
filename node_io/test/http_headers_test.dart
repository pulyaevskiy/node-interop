// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// @dart=2.9

@TestOn('node')
@JS()
library node_io.http_headers_test;

import 'dart:io';

import 'package:js/js.dart';
import 'package:node_interop/http.dart';
import 'package:node_interop/node.dart';
import 'package:node_interop/test.dart';
import 'package:node_io/src/http_headers.dart';
import 'package:test/test.dart';

const headersJS = '''
exports.request = {
  headers: {
    'host': 'localhost:80',
    'transfer-encoding': 'chunked',
    'content-type': 'text/html; charset=utf-8',
    'date': 'Thu, 1 Jan 1970 00:00:00 GMT',
    'expires': 'Thu, 1 Jan 1970 01:15:00 GMT',
    'if-modified-since': 'Thu, 1 Jan 1970 03:15:00 GMT',
    'connection': 'keep-alive',
    'set-cookie': [
      'Set-Cookie: id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly',
      'Set-Cookie: id=abcde; Expires=Wed, 22 Oct 2015 07:28:00 GMT;'
    ]
  }
};
exports.minimal = {
  headers: {
    'user-agent': 'curl/7.22.0'
  }
};
''';

@JS()
@anonymous
abstract class HeadersFixture {
  external IncomingMessage get request;
  external IncomingMessage get minimal;
}

void main() {
  final headersFile = createFile('headers.js', headersJS);

  group('RequestHttpHeaders', () {
    HeadersFixture jsHeaders = require(headersFile);
    var headers = RequestHttpHeaders(jsHeaders.request);
    var emptyHeaders = RequestHttpHeaders(jsHeaders.minimal);

    test('chunkedTransferEncoding', () async {
      expect(headers.chunkedTransferEncoding, isTrue);
      expect(emptyHeaders.chunkedTransferEncoding, isFalse);
    });

    test('contentType', () async {
      expect(headers.contentType, const TypeMatcher<ContentType>());
      expect(headers.contentType, same(headers.contentType));
      expect(emptyHeaders.contentType, isNull);
    });

    test('date', () async {
      expect(headers.date, const TypeMatcher<DateTime>());
      expect(emptyHeaders.date, isNull);
    });

    test('expires', () async {
      expect(headers.expires, const TypeMatcher<DateTime>());
      expect(emptyHeaders.expires, isNull);
    });

    test('host', () async {
      expect(headers.host, 'localhost');
      expect(emptyHeaders.host, isNull);
    });

    test('port', () {
      expect(headers.port, 80);
    });

    test('ifModifiedSince', () async {
      expect(headers.ifModifiedSince, const TypeMatcher<DateTime>());
      expect(emptyHeaders.ifModifiedSince, isNull);
    });

    test('persistentConnection', () async {
      expect(headers.persistentConnection, isTrue);
      expect(emptyHeaders.persistentConnection, isFalse);
    });

    test('[] operator', () async {
      expect(headers['transfer-encoding'], ['chunked']);
    });

    test('value', () async {
      expect(headers.value('transfer-encoding'), 'chunked');
      expect(() {
        headers.value('set-cookie');
      }, throwsA(const TypeMatcher<HttpException>()));
    });

    test('forEach', () {
      final map = {};
      headers.forEach((key, value) {
        map[key] = value;
      });
      expect(map['content-type'], [headers.contentType.toString()]);
    });

    test('getHeader', () {
      expect(headers.getHeader('content-type'), headers.contentType.toString());
    });
  });
}
