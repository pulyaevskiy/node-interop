// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js';

import 'package:http/http.dart';
import 'package:node_interop/http.dart' as nodeHttp;
import 'package:node_interop/https.dart' as nodeHttps;
import 'package:node_interop/node.dart';
import 'package:node_interop/util.dart';

/// HTTP client which uses Node.js I/O system.
///
/// Make sure to call [close] when work with this client is done.
class NodeClient extends BaseClient {
  /// Keep sockets around even when there are no outstanding requests, so they
  /// can be used for future requests without having to reestablish a TCP
  /// connection. Defaults to `true`.
  final bool keepAlive;

  /// When using the keepAlive option, specifies the initial delay for TCP
  /// Keep-Alive packets. Ignored when the keepAlive option is false.
  /// Defaults to 1000.
  final int keepAliveMsecs;

  NodeClient({
    this.keepAlive = true,
    this.keepAliveMsecs = 1000,
  });

  /// Native JavaScript connection agent used by this client for insecure
  /// requests.
  nodeHttp.HttpAgent get httpAgent =>
      _httpAgent ??= nodeHttp.createHttpAgent(new nodeHttp.HttpAgentOptions(
        keepAlive: keepAlive,
        keepAliveMsecs: keepAliveMsecs,
      ));
  nodeHttp.HttpAgent _httpAgent;

  /// Native JavaScript connection agent used by this client for secure
  /// requests.
  nodeHttp.HttpAgent get httpsAgent =>
      _httpsAgent ??= nodeHttps.createHttpsAgent(new nodeHttp.HttpAgentOptions(
        keepAlive: keepAlive,
        keepAliveMsecs: keepAliveMsecs,
      ));
  nodeHttp.HttpAgent _httpsAgent;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    var url = request.url;
    var usedAgent = (url.scheme == 'http') ? httpAgent : httpsAgent;
    var sendRequest = (url.scheme == 'http')
        ? nodeHttp.http.request
        : nodeHttps.https.request;

    var pathWithQuery =
        url.hasQuery ? [url.path, '?', url.query].join() : url.path;
    var options = new nodeHttp.RequestOptions(
        protocol: "${url.scheme}:",
        hostname: url.host,
        port: url.port,
        method: request.method,
        path: pathWithQuery,
        headers: jsify(request.headers),
        agent: usedAgent);
    var completer = new Completer<StreamedResponse>();

    void handleResponse(nodeHttp.IncomingMessage response) {
      final rawHeaders = dartify(response.headers) as Map<String, dynamic>;
      final headers = new Map<String, String>();
      for (var key in rawHeaders.keys) {
        final value = rawHeaders[key];
        headers[key] = (value is List) ? value.join(',') : value;
      }
      final controller = new StreamController<List<int>>();
      completer.complete(new StreamedResponse(
        controller.stream,
        response.statusCode,
        request: request,
        headers: headers,
        reasonPhrase: response.statusMessage,
      ));

      response.on('data', allowInterop((Iterable<int> buffer) {
        // buffer is an instance of Node's Buffer.
        controller.add(new List.unmodifiable(buffer));
      }));
      response.on('end', allowInterop(() {
        controller.close();
      }));
    }

    var nodeRequest = sendRequest(options, allowInterop(handleResponse));
    nodeRequest.on('error', allowInterop((e) {
      completer.completeError(e);
    }));
    ByteStream body = request.finalize();
    // TODO: Support StreamedRequest by consuming body asynchronously.
    body.toList().then((List<List<int>> chunks) {
      chunks.forEach((List<int> chunk) {
        var buffer = Buffer.from(chunk);
        nodeRequest.write(buffer);
      });
    }).catchError((error) {
      completer.completeError(error);
    }).whenComplete(() => nodeRequest.end());

    return completer.future;
  }

  @override
  void close() {
    httpAgent.destroy();
    httpsAgent.destroy();
  }
}
