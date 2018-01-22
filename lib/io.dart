// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// File, socket, HTTP, and other I/O support for server applications.
///
/// This library is designed to be a direct substitute to `dart:io`. It exposes
/// the same API interfaces but actual I/O is handled by NodeJS.
library node_interop.io;

import 'dart:async';
import 'dart:io' as io;
import 'src/http_server.dart';

export 'dart:io' show HttpRequest, HttpResponse, ContentType, HttpHeaders;
export 'src/internet_address.dart';
export 'src/http_server.dart';

/// Provides access to [NodeHttpServer].
///
/// This is a convenience class to expose static methods ([HttpServer.bind])
/// to conform to `dart:io` interface.
///
/// For actual implementation of [HttpServer] powered by Node I/O system see
/// [NodeHttpServer].
class HttpServer implements io.HttpServer {
  HttpServer._();

  static Future<io.HttpServer> bind(address, int port) =>
      NodeHttpServer.bind(address, port);

  @override
  noSuchMethod(Invocation invocation) => null;
}
