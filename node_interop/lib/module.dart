// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:web/web.dart';

import 'src/cjs/require.dart';

/// The Node.js [`node:module` module].
///
/// [`node:module` module]: https://nodejs.org/api/module.html#modules-nodemodule-api
final ModuleModule moduleModule = require('node:module');

/// The Node.js [`node:module` module].
///
/// [`node:module` module]: https://nodejs.org/api/module.html#modules-nodemodule-api
extension type ModuleModule._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/module.html#modulebuiltinmodules
  external JSArray<JSString> get builtinModules;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/module.html#modulecreaterequirefilename
  T Function<T extends JSAny?>(String id) createRequire(String filename) {
    var require = _createRequire(filename);
    return <T extends JSAny?>(id) => require.callAsFunction(id.toJS) as T;
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/module.html#modulecreaterequirefilename
  T Function<T extends JSAny?>(String id) createRequireForUrl(URL url) {
    var require = _createRequireForUrl(url);
    return <T extends JSAny?>(id) => require.callAsFunction(id.toJS) as T;
  }

  @JS('createRequire')
  external JSFunction _createRequire(String filename);

  @JS('createRequire')
  external JSFunction _createRequireForUrl(URL url);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/module.html#modulecreaterequirefilename
  @JS('createRequire')
  external RequireNamespace createRequireNamespace(String filename);

  @JS('createRequire')
  external RequireNamespace createRequireNamespaceForUrl(URL url);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/module.html#modulesyncbuiltinesmexports
  @JS('syncBuiltinESMExports')
  external void syncBuiltinEsmExports();
}
