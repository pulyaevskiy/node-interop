// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:node_interop/fs.dart';
import 'package:node_interop/node.dart';

void main() {
  fs.readdirSync(process.cwd());
}
