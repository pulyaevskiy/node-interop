// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')
import 'package:test/test.dart';

import 'buffer_test.dart' as buffer;
import 'child_process_test.dart' as child_process;
import 'console_test.dart' as console;
import 'js_test.dart' as js;
import 'promises_test.dart' as promises;
import 'stream_test.dart' as stream;
import 'timers_test.dart' as timers;
import 'util_test.dart' as util;

void main() {
  buffer.main();
  child_process.main();
  console.main();
  js.main();
  promises.main();
  stream.main();
  timers.main();
  util.main();
}
