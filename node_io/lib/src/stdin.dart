// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:node_interop/stream.dart';

import 'streams.dart';
import 'dart:io' as io;

class Stdin extends ReadableStream<List<int>> implements io.Stdin {
  Stdin(Readable nativeInstance) : super(nativeInstance);

  @override
  bool echoMode;

  @override
  bool lineMode;

  @override
  // TODO: implement hasTerminal
  bool get hasTerminal => null;

  @override
  int readByteSync() {
    // TODO: implement readByteSync
    return null;
  }

  @override
  String readLineSync(
      {Encoding encoding = io.systemEncoding, bool retainNewlines = false}) {
    // TODO: implement io.systemEncoding (!)
    // TODO: implement readLineSync
    return null;
  }

  @override
  // TODO: implement supportsAnsiEscapes
  bool get supportsAnsiEscapes => null;
}
