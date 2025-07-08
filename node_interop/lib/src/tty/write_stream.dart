// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:js_core/js_core.dart';

import '../../tty.dart';

// TODO: Extend `net.Socket` once we add typings for it
/// The Node.js [`tty.WriteStream` class].
///
/// [`tty.WriteStream` class]: https://nodejs.org/api/tty.html#class-ttywritestream
@anonymous
extension type TtyWriteStream<T extends JSAny>._(MaybeTtyWritable<T> _)
    implements MaybeTtyWritable<T> {
  /// Returns whether [value] is an instance of this type.
  static bool isA(JSAny? value) =>
      value.instanceof(tty.writeStreamClass as JSFunction);

  /// A broadcast stream wrapping [the `'resize'` event].
  ///
  /// [the `'resize'` event]: https://nodejs.org/api/tty.html#event-resize
  Stream<void> get onResize => eventAsStream('resize'.toJS).map((_) {});

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamcolumns
  external bool get columns;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamgetwindowsize
  (int, int) get windowSize {
    var result = _getWindowSize();
    return (result[0].toDartInt, result[1].toDartInt);
  }

  @JS('getWindowSize')
  external JSArray<JSNumber> _getWindowSize();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamrows
  external bool get rows;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#new-ttywritestreamfd
  factory TtyWriteStream(int fd) =>
      tty.writeStreamClass.construct(fd.toJS) as TtyWriteStream<T>;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamclearlinedir-callback
  bool clearLine(ClearLineDirection direction, [void Function()? callback]) =>
      callback == null
          ? _clearLine(direction._value)
          : _clearLine(direction._value, callback.toJS);

  @JS('clearLine')
  external bool _clearLine(int direction, [JSFunction? callback]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamclearscreendowncallback
  bool clearStreamDown([void Function()? callback]) =>
      callback == null ? _clearStreamDown() : _clearStreamDown(callback.toJS);

  @JS('clearStreamDown')
  external bool _clearStreamDown([JSFunction? callback]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamclearlinedir-callback
  bool cursorTo(int x, {int? y, void Function()? callback}) =>
      switch ((y, callback)) {
        (null, null) => _cursorToX(x),
        (null, var callback?) => _cursorToX(x, callback.toJS),
        (var y?, null) => _cursorToXY(x, y),
        (var y?, var callback?) => _cursorToXY(x, y, callback.toJS)
      };

  @JS('cursorTo')
  external bool _cursorToX(int x, [JSFunction? callback]);

  @JS('cursorTo')
  external bool _cursorToXY(int x, int y, [JSFunction? callback]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamgetcolordepthenv
  external int getColorDepth([JSRecord<JSString>? env]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamgetcolordepthenv
  bool hasColors({int? count, JSRecord<JSString>? env}) =>
      switch ((count, env)) {
        (null, null) => _hasColors(),
        (null, var env?) => _hasColors(env),
        (var count?, null) => _hasColorsCount(count),
        (var count?, var env?) => _hasColorsCount(count, env)
      };

  @JS('hasColors')
  external bool _hasColors([JSRecord<JSString>? env]);

  @JS('hasColors')
  external bool _hasColorsCount(int count, [JSRecord<JSString>? env]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/api/tty.html#writestreamclearlinedir-callback
  bool moveCursor(int dx, {int? dy, void Function()? callback}) =>
      switch ((dy, callback)) {
        (null, null) => _moveCursorDX(dx),
        (null, var callback?) => _moveCursorDX(dx, callback.toJS),
        (var dy?, null) => _moveCursorDXDY(dx, dy),
        (var dy?, var callback?) => _moveCursorDXDY(dx, dy, callback.toJS)
      };

  @JS('moveCursor')
  external bool _moveCursorDX(int dx, [JSFunction? callback]);

  @JS('moveCursor')
  external bool _moveCursorDXDY(int dx, int dy, [JSFunction? callback]);
}

enum ClearLineDirection {
  /// Clear to the left from the cursor.
  left._(-1),

  /// Clear to the right from the cursor.
  right._(1),
  // Clear the entire line.
  wholeLine._(0);

  /// The value to pass to [TtyWriteStream._clearLine].
  final int _value;

  const ClearLineDirection._(this._value);
}
