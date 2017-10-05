@JS()
library node_interop.bindings.events;

import 'package:js/js.dart';

/// Node's built-in EventEmitter interface.
@JS()
abstract class EventEmitter {
  external void on(String eventName, listener);
}
