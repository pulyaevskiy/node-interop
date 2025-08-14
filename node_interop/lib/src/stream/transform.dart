// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'duplex.dart';

/// The Node.js `Transform` stream.
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('stream.Transform')
extension type NodeTransform<T extends JSAny>.__(NodeDuplex _)
    implements NodeDuplex {
  factory NodeTransform({JSFunction? transform, JSFunction? flush}) {
    var options = _NewTransformOptions();
    if (transform != null) options.transform = transform;
    if (flush != null) options.flush = flush;
    return NodeTransform._(options);
  }

  external NodeTransform._([_NewTransformOptions options]);
}

/// Options for [Transform.new].
extension type _NewTransformOptions._(JSObject _) implements JSObject {
  external JSFunction? transform;
  external JSFunction? flush;

  factory _NewTransformOptions() => _NewTransformOptions._(JSObject());
}
