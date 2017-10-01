@JS()
library node_interop.bindings.events;

import 'package:js/js.dart';

@JS()
abstract class EventEmitter {
  external void on(String eventName, listener);
}
