// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'package:node_interop/fs.dart';
import 'package:node_io/node_io.dart';

String createPath(String name) {
  var segments = Platform.script.pathSegments.toList();
  segments
    ..removeLast()
    ..add(name);
  return Platform.pathSeparator + segments.join(Platform.pathSeparator);
}

String createFile(String name, String contents) {
  var jsFilepath = createPath(name);
  fs.writeFileSync(jsFilepath, contents);
  return jsFilepath;
}
