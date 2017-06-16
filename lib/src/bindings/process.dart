@JS()
library node_interop.bindings.process;

import 'package:js/js.dart';

@JS()
abstract class Process {
  external String get platform;
  external String cwd();
  external void chdir(String directory);
  external List<String> get execArgv;
  external String get execPath;
  external String get argv0;
  external dynamic get env;
}

@JS()
external Process get process;
