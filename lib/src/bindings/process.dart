@JS()
library node_interop.bindings.process;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

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

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

/// Returns Node environment variables as Dart `Map`.
Map<String, String> get envAsMap {
  var data = process.env;
  var result = new Map<String, String>();
  var keys = _getKeysOfObject(data);
  keys.forEach((key) {
    result[key] = getProperty(data, key);
  });
  return result;
}
