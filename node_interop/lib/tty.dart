// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "process" module bindings.
@JS()
library node_interop.tty;

import 'package:js/js.dart';

import 'net.dart';

/// Represents the readable side of a TTY.
@JS()
@anonymous
abstract class TTYReadStream extends Socket {
  /// A boolean that is true if the TTY is currently configured to operate as
  /// a raw device. Defaults to `false`.
  external bool get isRaw;

  /// A boolean that is always true for TTYReadStream instances.
  external bool get isTTY;
}

@JS()
@anonymous
abstract class TTYWriteStream extends Socket {
  /// A number specifying the number of columns the TTY currently has.
  ///
  /// This property is updated whenever the 'resize' event is emitted.
  external int get columns;

  external bool get isTTY;
}
