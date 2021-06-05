// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// HTTP client using Node I/O system for Dart.
///
/// See [NodeClient] for details.
library node_http;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'src/node_client.dart';

export 'package:http/http.dart'
    show
        BaseClient,
        BaseRequest,
        BaseResponse,
        StreamedRequest,
        StreamedResponse,
        Request,
        Response,
        ByteStream,
        ClientException;

export 'src/node_client.dart';

/// Sends an HTTP HEAD request with the given headers to the given URL, which
/// can be a [Uri] or a [String].
///
/// This automatically initializes a new [Client] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [Client] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<Response> head(url, {Map<String, String>? headers}) =>
    _withClient((client) => client.head(url, headers: headers));

/// Sends an HTTP GET request with the given headers to the given URL, which can
/// be a [Uri] or a [String].
///
/// This automatically initializes a new [Client] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [Client] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<Response> get(url, {Map<String, String>? headers}) =>
    _withClient((client) => client.get(url, headers: headers));

/// Sends an HTTP POST request with the given headers and body to the given URL,
/// which can be a [Uri] or a [String].
///
/// For more fine-grained control over the request, use [Request] or
/// [StreamedRequest] instead.
Future<Response> post(url,
        {Map<String, String>? headers, body, Encoding? encoding}) =>
    _withClient((client) =>
        client.post(url, headers: headers, body: body, encoding: encoding));

/// Sends an HTTP PUT request with the given headers and body to the given URL,
/// which can be a [Uri] or a [String].
///
/// For more fine-grained control over the request, use [Request] or
/// [StreamedRequest] instead.
Future<Response> put(url,
        {Map<String, String>? headers, body, Encoding? encoding}) =>
    _withClient((client) =>
        client.put(url, headers: headers, body: body, encoding: encoding));

/// Sends an HTTP PATCH request with the given headers and body to the given
/// URL, which can be a [Uri] or a [String].
///
/// For more fine-grained control over the request, use [Request] or
/// [StreamedRequest] instead.
Future<Response> patch(url,
        {Map<String, String>? headers, body, Encoding? encoding}) =>
    _withClient((client) =>
        client.patch(url, headers: headers, body: body, encoding: encoding));

/// Sends an HTTP DELETE request with the given headers to the given URL, which
/// can be a [Uri] or a [String].
///
/// This automatically initializes a new [Client] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [Client] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<Response> delete(url, {Map<String, String>? headers}) =>
    _withClient((client) => client.delete(url, headers: headers));

/// Sends an HTTP GET request with the given headers to the given URL, which can
/// be a [Uri] or a [String], and returns a Future that completes to the body of
/// the response as a [String].
///
/// The Future will emit a [ClientException] if the response doesn't have a
/// success status code.
///
/// This automatically initializes a new [Client] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [Client] for all of those requests.
///
/// For more fine-grained control over the request and response, use [Request]
/// instead.
Future<String> read(url, {Map<String, String>? headers}) =>
    _withClient((client) => client.read(url, headers: headers));

Future<T> _withClient<T>(Future<T> Function(Client client) fn) async {
  var client = NodeClient();
  try {
    return await fn(client);
  } finally {
    client.close();
  }
}
