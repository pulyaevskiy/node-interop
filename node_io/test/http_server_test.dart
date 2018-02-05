// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
@TestOn('node')
library node_interop.http_server_test;

import 'dart:convert';

import 'package:js/js.dart';
import 'package:node_io/node_io.dart';
import 'package:node_http/node_http.dart';
import 'package:test/test.dart';

void main() {
  group('HttpServer', () {
    HttpServer server;

    setUpAll(() async {
      server = await HttpServer.bind('127.0.0.1', 8181);
      server.listen((request) async {
        String body = await request.map(UTF8.decode).join();
        request.response.headers.contentType = ContentType.TEXT;
        request.response.headers.set('X-Foo', 'bar');
        request.response.statusCode = 200;
        if (body != null && body.isNotEmpty) {
          final json = JSON.decode(body);
          request.response.write(JSON.encode(json));
        } else {
          request.response.write('ok');
        }
        request.response.close();
      });
    });

    tearDownAll(() async {
      await server.close();
    });

    test('request with body', () async {
      final client = new NodeClient(keepAlive: false);
      var res =
          await client.post('http://127.0.0.1:8181', body: '{"pi": 3.14}');
      expect(res.body, '{"pi":3.14}');
    });
  });
}
