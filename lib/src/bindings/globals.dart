// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.globals;

import 'package:js/js.dart';

/// Returns a list of keys in [jsObject].
///
/// This function binds to JavaScript `Object.keys()`.
@JS('Object.keys')
external List<String> jsObjectKeys(jsObject);

@JS()
abstract class Promise {
  external factory Promise(executor(Function resolve, Function reject));
  external Promise then(Function onFulfilled, [Function onRejected]);
}

/// Requires (imports) a module specified by [id].
///
/// Example using "dns" module:
///
///     DNS dns = require('dns');
///     var options = new DNSLookupOptions(all: true, verbatim: true);
///     void lookupHandler(error, List<DNSAddress> addresses) {
///       console.log(addresses);
///     }
///     dns.lookup('google.com', options, allowInterop(lookupHandler));
@JS()
external dynamic require(String id);

/// Reference to Node's `module` object;
///
/// See also:
///   - [https://nodejs.org/api/modules.html#modules_the_module_object](https://nodejs.org/api/modules.html#modules_the_module_object)
@JS()
external Module get module;

@JS()
abstract class Module {
  external dynamic get children;
  external dynamic get exports;
  external set exports(value);
}

/// Returns reference to Node's `exports` object.
@JS()
external dynamic get exports;

/// Replaces current module exports with [value].
///
/// Use with care, this effectively detaches `exports` from `module.exports`.
///
/// See also:
///   - [https://nodejs.org/api/modules.html#modules_exports_shortcut](https://nodejs.org/api/modules.html#modules_exports_shortcut)
@JS()
external set exports(dynamic value);

@JS('__dirname')
external String get nodeDirname;

@JS('__filename')
external String get nodeFilename;

@JS()
abstract class Date {
  external String toISOString();
}

@JS()
external Console get console;

@JS('console.Console')
abstract class Console {
  external void log(data, [List args]);
  external void error(data, [List args]);
  external void info(data, [List args]);
  external void warn(data, [List args]);
  external factory Console(stdout, [stderr]);
}

@JS()
abstract class Buffer {
  external static from(Iterable<int> bytes);
}
