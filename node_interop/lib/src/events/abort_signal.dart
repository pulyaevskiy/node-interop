// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:js_core/js_core.dart';
import 'package:web/web.dart';

import '../../events.dart';

extension AbortSignalExtension on AbortSignal {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#eventsaddabortlistenersignal-listener
  Disposable addAbortListener(JSFunction listener) =>
      events.addAbortListener(this, listener);
}
