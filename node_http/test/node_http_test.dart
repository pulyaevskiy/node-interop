// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
library http_test;

import 'dart:convert';

import 'package:node_http/node_http.dart';
import 'package:node_io/node_io.dart';
import 'package:test/test.dart';

void main() {
  group('HTTP client', () {
    HttpServer server;

    setUpAll(() async {
      server = await HttpServer.bind('127.0.0.1', 8181);
      server.listen((request) async {
        String body = await request.map(UTF8.decode).join();
        request.response.headers.contentType = ContentType.TEXT;
        request.response.headers.set('X-Foo', 'bar');
        request.response.statusCode = 200;
        if (body != null && body.isNotEmpty) {
          request.response.write(body);
        } else {
          request.response.write('ok');
        }
        request.response.close();
      });
    });

    tearDownAll(() async {
      await server.close();
    });

    test('make get request', () async {
      var client = new NodeClient();
      var response = await client.get('http://127.0.0.1:8181/test');
      expect(response.statusCode, 200);
      expect(response.contentLength, greaterThan(0));
      expect(response.body, equals('ok'));
      expect(response.headers, contains('content-type'));
      client.close();
    });

    test('make post request with a body', () async {
      var client = new NodeClient();
      var response =
          await client.post('http://127.0.0.1:8181/test', body: 'hello');
      expect(response.statusCode, 200);
      expect(response.contentLength, greaterThan(0));
      expect(response.body, equals('hello'));
      client.close();
    });
  });
}
