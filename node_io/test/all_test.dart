// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'package:test/test.dart';

import 'directory_test.dart' as directory;
import 'file_stat_test.dart' as file_stat;
import 'file_test.dart' as file;
import 'http_headers_test.dart' as http_headers;
import 'http_server_test.dart' as http_server;
import 'internet_address_test.dart' as internet_address;
import 'platform_test.dart' as platform;

void main() {
  directory.main();
  file_stat.main();
  file.main();
  http_headers.main();
  http_server.main();
  internet_address.main();
  platform.main('all_test.dart');
}
