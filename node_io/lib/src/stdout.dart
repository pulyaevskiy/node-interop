// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io' as io;

import 'package:node_interop/tty.dart';

import 'streams.dart';

class Stdout extends NodeIOSink implements io.Stdout {
  Stdout(TTYWriteStream nativeStream) : super(nativeStream);

  @override
  TTYWriteStream get nativeInstance => super.nativeInstance;

  @override
  bool get hasTerminal => nativeInstance.isTTY;

  @override
  io.IOSink get nonBlocking =>
      throw UnsupportedError('Not supported by Node.js');

  @override
  // This is not strictly accurate but Dart's own implementation is a
  // best-effort solution as well, so we allow ourselves a bit of a slack here
  // too.
  bool get supportsAnsiEscapes => nativeInstance.getColorDepth() > 1;

  @override
  int get terminalColumns => nativeInstance.columns;

  @override
  int get terminalLines => nativeInstance.rows;
}
