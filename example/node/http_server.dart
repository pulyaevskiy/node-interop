// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:convert';

import 'package:node_interop/io.dart';

// Example HTTP server using "dart:io" wrappers (not finished yet).
main() async {
  const int port = 8080;
  final HttpServer server = await HttpServer.bind('127.0.0.1', port);
  print('Server started on port $port.');
  server.listen((HttpRequest request) {
    print('${request.method} ${request.uri}');
    request.response.headers.contentType = ContentType.JSON;
    request.response.write(JSON.encode({'requestedUri': '${request.uri}'}));
    request.response.close();
  });
}
