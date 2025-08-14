// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:web/web.dart';

/// The [Node.js `buffer.File` class].
///
/// [Node.js `buffer.File` class]: https://nodejs.org/docs/latest/api/buffer.html#class-file
///
/// This is safe to use with [JSAnyUtilityExtension.isA].
@JS('buffer.File')
extension type BufferFile.__(Blob _) implements Blob {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#filename
  external String get name;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#filelastmodified
  external int get lastModified;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/buffer.html#new-bufferfilesources-filename-options
  factory BufferFile(JSArray<JSAny> sources, String fileName,
      {BufferFileEndingType? endings, String? type, int? lastModified}) {
    var options = _NewBufferFileOptions();
    if (endings != null) options.endings = endings.name;
    if (type != null) options.type = type;
    if (lastModified != null) options.lastModified = lastModified;
    return BufferFile._(sources, fileName, options);
  }

  external BufferFile._(
      JSArray<JSAny> sources, String fileName, _NewBufferFileOptions options);
}

/// The types of line endings supported by [BufferFile.new].
enum BufferFileEndingType { transparent, native }

/// Options for [BufferFile.new].
extension type _NewBufferFileOptions._(JSObject _) implements JSObject {
  external String endings;
  external String type;
  external int lastModified;

  factory _NewBufferFileOptions() => _NewBufferFileOptions._(JSObject());
}
