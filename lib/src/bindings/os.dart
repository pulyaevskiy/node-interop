@JS()
library node_interop.bindings.os;

import 'package:js/js.dart';
import 'globals.dart';

NodeOS _os;
NodeOS get os {
  if (_os != null) return _os;
  _os = require('os');
  return _os;
}

@JS()
@anonymous
abstract class NodeOS {
  external List<NodeCPU> cpus();
  external String tmpdir();
  external String hostname();
}

@JS()
@anonymous
abstract class NodeCPU {}
