// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NodeJS buffer module.
///
/// Normally there should be no need to import this module directly as
/// [Buffer] class is available globally.
@JS()
library node_interop.buffer;

import 'package:js/js.dart';

@JS()
abstract class Buffer {
  /// Creates a new Buffer from data.
  external static Buffer from(data, [arg1, arg2]);
}
