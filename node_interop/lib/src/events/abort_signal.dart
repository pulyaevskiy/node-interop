// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

@JS('events.addAbortListener')
external Disposable _addAbortListener(AbortSignal signal, JSFunction listener);

extension AbortSignalExtension on AbortSignal {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsaddabortlistenersignal-listener
  Disposable addAbortListener(JSFunction listener) =>
      _addAbortListener(this, listener);
}
