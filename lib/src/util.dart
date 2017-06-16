@JS()
library node_interop.js_util;

import 'dart:js';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

/// Returns Node environment variables as Dart `Map`.
Map<String, dynamic> jsObjectToMap(JsObject object) {
  var result = new Map<String, dynamic>();
  var keys = _getKeysOfObject(object);
  keys.forEach((key) {
    result[key] = getProperty(object, key);
  });
  return result;
}
