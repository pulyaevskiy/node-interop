// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:node_interop/fs.dart';
import 'package:node_interop/node.dart';

/// Simple example of reading contents of current working directory and
/// printing out as nicely indented JSON.
void main() {
  final contents = List<String>.from(fs.readdirSync(process.cwd()));
  final json = JsonEncoder.withIndent('  ');
  print(json.convert(contents));
}
