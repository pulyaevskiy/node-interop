// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "querystring" module bindings.
///
/// Use library-level [querystring] object to access functionality of this module.
@JS()
library node_interop.querystring;

import 'package:js/js.dart';

import 'node.dart';

QueryString get querystring => _querystring ??= require('querystring');
QueryString _querystring;

@JS()
@anonymous
abstract class QueryString {
  external String escape(String str);
  external dynamic parse(String str, [String sep, String eq, options]);
  external String stringify(obj, [String sep, String eq, options]);
  external String unescape(String str);
}
