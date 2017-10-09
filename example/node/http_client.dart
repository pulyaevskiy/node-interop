// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:node_interop/http.dart';

// Example of using Dart-style HTTP client. Enjoy.
main() async {
  var http = new NodeClient();
  var response = await http.get('https://www.google.com');
  print(response.statusCode);
  print(response.body);
}
