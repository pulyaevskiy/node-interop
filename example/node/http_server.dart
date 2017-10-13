// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:convert';

import 'package:js/js.dart';
import 'package:node_interop/http.dart';
import 'package:node_interop/node_interop.dart';

// Example HTTP server using "dart:io" wrappers (not finished yet).
main() async {
  HTTP http = node.require('http');
  var server = http.createServer(allowInterop((req, res) {
    var request = new HttpRequest(req, res);
    print('Request: ${request.requestedUri}');
    request.response.headers.contentType = ContentType.JSON;
    request.response.write(JSON.encode({"dart": "OK"}));
    request.response.close();
  }));

  server.listen(8080);
}
