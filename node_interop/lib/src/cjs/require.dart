// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

import 'module.dart';

/// The module-scoped [`require()` function].
///
/// [`require()` function]: https://nodejs.org/api/modules.html#requireid
///
/// This throws a [NodeReferenceError] if the compiled JS file is loaded as an
/// ES6 module.
@JS()
external T require<T extends JSAny?>(String id);

/// The namespace for values exposed on the `require` function in Node.js.
///
/// This throws a [NodeReferenceError] if the compiled JS file is loaded as an
/// ES6 module.
@JS('require')
external RequireNamespace get requireNamespace;

/// The namespace for values exposed on the `require` function in Node.js.
extension type RequireNamespace._(JSObject _) implements JSObject {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#requiremain
  external NodeModule? get main;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/modules.html#requireresolverequest-options
  String resolve(String request, {List<String>? paths}) => paths == null
      ? _resolve(request)
      : _resolve(request, _ResolveOptions(paths: paths.toJS));

  @JS('resolve')
  external String _resolve(String request, [_ResolveOptions? options]);

  List<String>? resolvePaths(String request) =>
      _resolveNamespace.paths(request)?.toDart;

  @JS('resolve')
  external _ResolveNamespace get _resolveNamespace;

  /// Invokes this as a `require()` function.
  T call<T extends JSAny?>(String id) =>
      (this as JSFunction).callAsFunction(id.toJS) as T;
}

/// Options for [RequireNamespace.resolve].
extension type _ResolveOptions._(JSObject _) implements JSObject {
  external JSArray<JSString> paths;

  external _ResolveOptions({JSArray<JSString>? paths});
}

/// The namespace used for [RequireNamespace.resolve].
extension type _ResolveNamespace._(JSObject _) implements JSObject {
  external JSArray<JSString>? paths(String request);
}
