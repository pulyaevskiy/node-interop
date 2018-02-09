// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library node_interop.events;

import 'package:js/js.dart';

@JS()
abstract class EventEmitter {
  external void emit(String eventName, [arg1, arg2, arg3, arg4, arg5, arg6]);
  external EventEmitter on(String eventName, Function listener);
  external void removeAllListeners(String eventName);
}
