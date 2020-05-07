// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io' as io;

import 'package:node_interop/stream.dart';

import 'streams.dart';

class Stdout extends NodeIOSink implements io.Stdout {
  Stdout(Writable nativeStream) : super(nativeStream);

  @override
  // TODO: implement hasTerminal
  bool get hasTerminal => null;

  @override
  // TODO: implement nonBlocking
  io.IOSink get nonBlocking => null;

  @override
  // TODO: implement supportsAnsiEscapes
  bool get supportsAnsiEscapes => null;

  @override
  // TODO: implement terminalColumns
  int get terminalColumns => null;

  @override
  // TODO: implement terminalLines
  int get terminalLines => null;
}
