// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// HTTP client implementation for Node.
@JS()
library node_interop.http;

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:js/js.dart';

import 'bindings.dart';
import 'src/util.dart';

final HTTP _nodeHTTP = require('http');

/// HTTP client which uses Node IO (via 'http' module).
class NodeClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var url = request.url;
    var pathWithQuery =
        url.hasQuery ? [url.path, '?', url.query].join() : url.path;
    var options = new RequestOptions(
      protocol: "${url.scheme}:",
      hostname: url.host,
      port: url.port,
      method: request.method,
      path: pathWithQuery,
      headers: request.headers,
    );
    var completer = new Completer<http.StreamedResponse>();

    void handleResponse(IncomingMessage response) {
      Map<String, dynamic> headers = jsObjectToMap(response.headers);
      var controller = new StreamController<List<int>>();
      completer.complete(new http.StreamedResponse(
        controller.stream,
        response.statusCode,
        request: request,
        headers: headers,
        reasonPhrase: response.statusMessage,
      ));

      response.on('data', allowInterop((Buffer buffer) {
        controller.add(new List.unmodifiable(buffer));
      }));
      response.on('end', allowInterop(() {
        controller.close();
      }));
    }

    var nodeRequest = _nodeHTTP.request(options, allowInterop(handleResponse));
    nodeRequest.on('error', allowInterop((e) {
      completer.completeError(e.message);
    }));
    http.ByteStream body = request.finalize();
    // TODO: Support StreamedRequest by consuming body asynchronously.
    body
        .toList()
        .then((List<List<int>> chunks) {
          chunks.forEach((List<int> chunk) {
            var buffer = Buffer.from(chunk);
            nodeRequest.write(buffer);
          });
        })
        .catchError(completer.completeError)
        .whenComplete(() => nodeRequest.end());

    return completer.future;
  }

  @override
  void close() {
    // TODO: Create own instance of http.Agent and handle lifecycle internally.
    _nodeHTTP.globalAgent.destroy();
  }
}
