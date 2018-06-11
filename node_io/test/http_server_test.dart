// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'dart:async';
import 'dart:convert';

import 'dart:js';
import 'package:node_io/node_io.dart';
import 'package:node_interop/http.dart' as js;
import 'package:test/test.dart';

void main() {
  group('HttpServer', () {
    HttpServer server;

    setUpAll(() async {
      server = await HttpServer.bind('127.0.0.1', 8181);
      server.listen((request) async {
        String body = await request.map(utf8.decode).join();
        request.response.headers.contentType = ContentType.text;
        request.response.headers.set('X-Foo', 'bar');
        request.response.statusCode = 200;
        if (body != null && body.isNotEmpty) {
          final jsonData = json.decode(body);
          request.response.write(json.encode(jsonData));
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
      String response =
          await makePost(Uri.parse('http://127.0.0.1:8181'), '{"pi": 3.14}');
      expect(response, '{"pi":3.14}');
    });
  });
}

Future<String> makePost(Uri url, String body) {
  final completer = new Completer<String>();
  final options = new js.RequestOptions(
    method: 'POST',
    protocol: '${url.scheme}:',
    hostname: url.host,
    port: 8181,
  );
  final request = js.http.request(options, allowInterop((response) {
    response.setEncoding('utf8');
    StringBuffer body = new StringBuffer();
    response.on('data', allowInterop((chunk) {
      body.write(chunk);
    }));
    response.on('end', allowInterop(() {
      completer.complete(body.toString());
    }));
  }));
  request.write(body);
  request.end();

  return completer.future;
}
