// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io' as io;

import 'package:node_interop/tty.dart';

import 'streams.dart';

class Stdin extends ReadableStream<List<int>> implements io.Stdin {
  Stdin(TTYReadStream nativeInstance) : super(nativeInstance);

  @override
  TTYReadStream get nativeInstance => super.nativeInstance;

  @override
  bool echoMode;

  @override
  bool lineMode;

  @override
  bool get hasTerminal => nativeInstance.isTTY;

  @override
  int readByteSync() {
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
