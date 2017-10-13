// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library node_interop.bindings.events;

import 'package:js/js.dart';

/// Node's built-in EventEmitter interface.
@JS()
abstract class EventEmitter {
  external void on(String eventName, listener);
  external void removeAllListeners([String eventName]);
}
