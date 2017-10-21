// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
@TestOn('node')
library node_interop.http_server_test;

import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';
import 'package:node_interop/src/http_server.dart';
import 'package:node_interop/test.dart';
import 'package:test/test.dart';

final HTTP nodeHTTP = require('http');

const fixturesJS = '''
function NodeHttpRequestStub(headers) {
  this.headers = headers;
  this.socket = new NetSocketStub();
}
NodeHttpRequestStub.prototype.on = function(name, callback) {};

function NodeHttpResponseStub() {
}

NodeHttpResponseStub.prototype.on = function(name, callback) {};

NodeHttpResponseStub.prototype.end = function(callback) {
  callback();
};

function NetSocketStub() {};
NetSocketStub.prototype.address = function() {
  return {port: 80, family: 'IPv4', address: '127.0.0.1'};
};

var headers = {
  'transfer-encoding': 'chunked',
  'content-type': 'text/html; charset=utf-8',
  'date': 'Thu, 1 Jan 1970 00:00:00 GMT',
  'expires': 'Thu, 1 Jan 1970 01:15:00 GMT',
  'host': 'example.com',
  'if-modified-since': 'Thu, 1 Jan 1970 03:15:00 GMT',
  'connection': 'keep-alive',
  'set-cookie': ['id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly']
};

exports.request = new NodeHttpRequestStub(headers);
exports.response = new NodeHttpResponseStub();
''';

@JS()
abstract class HttpFixtures {
  external dynamic get request;
  external dynamic get response;
}

void main() {
  createFile('fixtures.js', fixturesJS);
  HttpFixtures fixtures = node.require('./fixtures.js');

  group('HttpRequest', () {
    var request = new HttpRequest(fixtures.request, fixtures.response);

    test('headers', () {
      expect(request.headers, isNotNull);
      expect(request.headers, same(request.headers));
    });

    test('cookies', () {
      expect(request.cookies, isList);
      expect(request.cookies, isNotEmpty);
      expect(request.cookies.first, new isInstanceOf<Cookie>());
    });
  });

  group('HttpResponse', () {
    var request = new HttpRequest(fixtures.request, fixtures.response);

    test('close()', () {
      expect(request.response.close(), completes);
    });
  });
}
