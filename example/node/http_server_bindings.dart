// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';

// Example HTTP server using NodeJS bindings directly.
main() async {
  HTTP http = node.require('http');
  var server = http.createServer(allowInterop((req, res) {
    console.log('Received request ${req.url}');
    console.log(req.headers);
    console.log(req.rawHeaders);
    console.log(req.rawTrailers);
    res.end('OK');
  }));

  server.listen(8080);
}
