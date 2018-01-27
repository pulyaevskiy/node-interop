// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
@JS()
library http_test;

import 'dart:async';
import 'dart:js';

import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart' as node;
import 'package:node_interop/http.dart' as http;
import 'package:test/test.dart';

@JS()
external dynamic require(id);

final node.HTTP nodeHTTP = require('http');

void main() {
  group('HTTP client', () {
    var server;

    setUpAll(() {
      server = nodeHTTP.createServer(
          allowInterop((node.IncomingMessage req, node.ServerResponse res) {
        List<int> body = [];
        req.on('data', allowInterop((Iterable<int> chunk) {
          body.addAll(chunk);
        }));

        req.on('end', allowInterop(() {
          res.setHeader('Content-Type', 'text/plain');
          res.setHeader('X-Foo', 'bar');
          res.writeHead(200, 'Ok');
          var bodyString =
              body.isNotEmpty ? new String.fromCharCodes(body) : 'ok';
          res.end(bodyString);
        }));
      }));

      var completer = new Completer();
      server.listen(8181, allowInterop(() {
        completer.complete();
      }));
      return completer.future;
    });

    tearDownAll(() {
      var completer = new Completer();
      server.close(allowInterop(() {
        completer.complete();
      }));
      return completer.future;
    });

    test('make get request', () async {
      var client = new http.NodeClient();
      var response = await client.get('http://localhost:8181/test');
      expect(response.statusCode, 200);
      expect(response.contentLength, greaterThan(0));
      expect(response.body, equals('ok'));
      expect(response.headers, contains('content-type'));
      client.close();
    });

    test('make post request with a body', () async {
      var client = new http.NodeClient();
      var response =
          await client.post('http://localhost:8181/test', body: 'hello');
      expect(response.statusCode, 200);
      expect(response.contentLength, greaterThan(0));
      expect(response.body, equals('hello'));
      client.close();
    });
  });
}
