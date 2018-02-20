// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "events" module bindings.
@JS()
library node_interop.events;

import 'package:js/js.dart';

@JS()
@anonymous
abstract class EventEmitter {
  external static int get defaultMaxListeners;
  external static set defaultMaxListeners(int value);
  external void addListener(eventName, Function listener);
  external void emit(eventName, [arg1, arg2, arg3, arg4, arg5, arg6]);
  external List eventNames();
  external int getMaxListeners();
  external int listenerCount(eventName);
  external List<Function> listeners(eventName);
  external EventEmitter on(eventName, Function listener);
  external EventEmitter once(eventName, Function listener);
  external EventEmitter prependListener(eventName, Function listener);
  external EventEmitter prependOnceListener(eventName, Function listener);
  external EventEmitter removeAllListeners(eventName);
  external EventEmitter removeListener(eventName, Function listener);
  external void setMaxListeners(int value);
  external List<Function> rawListeners(eventName);
}
