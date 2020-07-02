// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "module" module bindings.
///
/// This library does not declare library-level getter for the module in order
/// to avoid name collision with a `module` object available in each module.
@JS()
library node_interop.module;

import 'package:js/js.dart';

@JS()
@anonymous
abstract class Modules {
  external List<String> get builtinModules;
}

@JS()
@anonymous
abstract class Module {
  external List<Module> get children;
  external dynamic get exports;
  external String get filename;
  external String get id;
  external bool get loaded;
  external Module get parent;
  external List<String> get paths;
  external dynamic require(String id);
}
