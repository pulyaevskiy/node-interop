// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

import '../../events.dart';

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#class-nodeeventtarget
extension type NodeEventTarget._(EventTarget _) implements EventTarget {
  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargetemittype-arg
  external bool emit(String eventName, JSAny? arg);

  @JS('eventNames')
  external JSArray<JSString> _eventNames();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargeteventnames
  List<String> get eventNames => _eventNames().toDart;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargetlistenercounttype
  external int listenerCount(String eventName);

  @JS('getMaxListeners')
  external int _getMaxListeners();
  @JS('setMaxListeners')
  external void _setMaxListeners(int value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargetgetmaxlisteners
  int get maxListeners => _getMaxListeners();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargetsetmaxlistenersn
  set maxListeners(int value) => _setMaxListeners(value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargetoncetype-listener
  external void once(String eventName, JSFunction listener);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/events.html#nodeeventtargetremovealllistenerstype
  external void removeAllListeners([String eventName]);
}
