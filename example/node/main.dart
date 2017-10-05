// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:node_interop/node_interop.dart';
import 'package:node_interop/fs.dart';

main() async {
  var fs = const NodeFileSystem();
  var dir = fs.currentDirectory;
  print(dir);
  var files = dir.list().toList();
  print(files);
  var stat = await fs.stat(dir.path);
  print(stat);

  const platform = const NodePlatform();
  print(platform.environment);
}
