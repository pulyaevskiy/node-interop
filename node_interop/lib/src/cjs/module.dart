// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

/// The currently-loaded module.
///
/// This throws a [NodeReferenceError] if the compiled JS file is loaded as an
/// ES6 module.
external NodeModule get module;

/// A Node.js [`module` object].
///
/// [`module` object]: https://nodejs.org/api/modules.html#the-module-object
extension type NodeModule._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#modulechildren
  external JSArray<NodeModule> get children;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#moduleexports
  external JSRecord<JSAny?> get exports;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#moduleexports
  external set exports(JSAny? value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#modulefilename
  external String get filename;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#moduleid
  external String get id;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#moduleispreloading
  external bool get isPreloading;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#moduleloaded
  external bool get loaded;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#modulepath
  external String get path;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#modulepaths
  external JSArray<JSString> get paths;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#modulerequireid
  external T require<T extends JSAny?>(String id);
}
