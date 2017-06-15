@JS()
library node_interop.bindings.globals;

import 'package:js/js.dart';

@JS()
external dynamic require(String id);

@JS()
external dynamic get exports;

String get dirname => __dirname;
String get filename => __filename;

@JS()
external String get __dirname;

@JS()
external String get __filename;
