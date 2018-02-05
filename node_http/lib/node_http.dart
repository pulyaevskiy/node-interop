// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// HTTP client using Node I/O system.
///
/// See [NodeClient] for details.
library node_http;

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:js/js.dart';
import 'package:node_interop/http.dart' as _http;
import 'package:node_interop/https.dart' as _https;
import 'package:node_interop/node.dart';
import 'package:node_interop/util.dart';

export 'package:http/http.dart';

/// Sends an HTTP GET request with the given headers to the given URL, which can
/// be a [Uri] or a [String].
///
/// This automatically initializes a new [Client] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [Client] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<http.Response> get(url, {Map<String, String> headers}) =>
    _withClient((client) => client.get(url, headers: headers));

Future<T> _withClient<T>(Future<T> fn(http.Client client)) async {
  var client = new NodeClient();
  try {
    return await fn(client);
  } finally {
    client.close();
  }
}

/// HTTP client which uses Node I/O system.
///
/// Make sure to call [close] when work with this client is done.
class NodeClient extends http.BaseClient {
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
  _http.HttpAgent get httpAgent =>
      _httpAgent ??= _http.createHttpAgent(new _http.HttpAgentOptions(
        keepAlive: keepAlive,
        keepAliveMsecs: keepAliveMsecs,
      ));
  _http.HttpAgent _httpAgent;

  /// Native JavaScript connection agent used by this client for secure
  /// requests.
  _http.HttpAgent get httpsAgent =>
      _httpsAgent ??= _https.createHttpsAgent(new _http.HttpAgentOptions(
        keepAlive: keepAlive,
        keepAliveMsecs: keepAliveMsecs,
      ));
  _http.HttpAgent _httpsAgent;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var url = request.url;
    var usedAgent = (url.scheme == 'http') ? httpAgent : httpsAgent;
    var sendRequest =
        (url.scheme == 'http') ? _http.http.request : _https.https.request;

    var pathWithQuery =
        url.hasQuery ? [url.path, '?', url.query].join() : url.path;
    var options = new _http.RequestOptions(
        protocol: "${url.scheme}:",
        hostname: url.host,
        port: url.port,
        method: request.method,
        path: pathWithQuery,
        headers: jsify(request.headers),
        agent: usedAgent);
    var completer = new Completer<http.StreamedResponse>();

    void handleResponse(_http.IncomingMessage response) {
      Map<String, dynamic> headers = dartify(response.headers);
      var controller = new StreamController<List<int>>();
      completer.complete(new http.StreamedResponse(
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
    httpAgent.destroy();
    httpsAgent.destroy();
  }
}
