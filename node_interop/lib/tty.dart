// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "process" module bindings.
///
/// The tty module provides the [TTYReadStream] and [TTYWriteStream] classes.
/// In most cases, it will not be necessary or possible to use this module
/// directly. However, it can be accessed using:
///
///     import 'package:node_interop/tty.dart';
///
///     void main() {
///       // For example:
///       print(tty.isatty(fileDescriptor));
///     }
///
/// When Node.js detects that it is being run with a text terminal ("TTY")
/// attached, `process.stdin` will, by default, be initialized as an instance
/// of [TTYReadStream] and both `process.stdout` and `process.stderr` will,
/// by default be instances of [TTYWriteStream]. The preferred method of
/// determining whether Node.js is being run within a TTY context is to check
/// that the value of the `process.stdout.isTTY` property is `true`.
///
/// In most cases, there should be little to no reason for an application to
/// manually create instances of the [TTYReadStream] and [TTYWriteStream]
/// classes.
@JS()
library node_interop.tty;

import 'package:js/js.dart';

import 'net.dart';
import 'node.dart';

TTY get tty => _tty ??= require('tls');
TTY _tty;

@JS()
@anonymous
abstract class TTY {
  /// Returns `true` if the given [fd] is associated with a TTY and `false` if
  /// it is not, including whenever fd is not a non-negative integer.
  external bool isatty(num fd);
}

/// Represents the readable side of a TTY.
@JS()
@anonymous
abstract class TTYReadStream extends Socket {
  /// A boolean that is true if the TTY is currently configured to operate as
  /// a raw device. Defaults to `false`.
  external bool get isRaw;

  /// A boolean that is always true for TTYReadStream instances.
  external bool get isTTY;

  /// Allows configuration of this stream so that it operates as a raw device.
  ///
  /// When in raw mode, input is always available character-by-character, not
  /// including modifiers. Additionally, all special processing of characters
  /// by the terminal is disabled, including echoing input characters. `CTRL+C`
  /// will no longer cause a `SIGINT` when in this mode.
  external TTYReadStream setRawMode(bool mode);
}

@JS()
@anonymous
abstract class TTYWriteStream extends Socket {
  /// Clears the current line of this stream in a direction identified by [dir].
  ///
  /// Returns `false` if the stream wishes for the calling code to wait for the
  /// 'drain' event to be emitted before continuing to write additional data;
  /// otherwise returns true.
  ///
  /// The [dir] argument can be set to:
  ///   `-1`: to the left from cursor
  ///   `1`: to the right from cursor
  ///   `0`: the entire line
  external bool clearLine(num dir, [void Function() callback]);

  /// Clears this stream from the current cursor down.
  ///
  /// Returns `false` if the stream wishes for the calling code to wait for the
  /// 'drain' event to be emitted before continuing to write additional data;
  /// otherwise returns true.
  external bool clearScreenDown([void Function() callback]);

  /// A number specifying the number of columns the TTY currently has.
  ///
  /// This property is updated whenever the 'resize' event is emitted.
  external int get columns;

  /// Moves this stream's cursor to the specified position.
  ///
  /// Returns `false` if the stream wishes for the calling code to wait for the
  /// 'drain' event to be emitted before continuing to write additional data;
  /// otherwise returns true.
  external bool cursorTo(num x, [num y, void Function() callback]);

  /// Use this to determine what colors the terminal supports.
  ///
  /// Due to the nature of colors in terminals it is possible to either have
  /// false positives or false negatives. It depends on process information and
  /// the environment variables that may lie about what terminal is used. It is
  /// possible to pass in an env object to simulate the usage of a specific
  /// terminal. This can be useful to check how specific environment settings
  /// behave.
  ///
  /// The optional [env] argument can be used to pass environment variables to
  /// check. This enables simulating the usage of a specific terminal.
  /// Default: `process.env`.
  external num getColorDepth([dynamic env]);

  /// Returns the size of the TTY corresponding to this stream.
  ///
  /// The returned array is of the type [numColumns, numRows] where numColumns
  /// and numRows represent the number of columns and rows in the corresponding
  /// TTY.
  external List<num> getWindowSize();

  /// Returns true if this stream supports at least as many colors as provided
  /// in count.
  ///
  /// Minimum support is 2 (black and white).
  ///
  /// This has the same false positives and negatives as described in
  /// [getColorDepth].
  external bool hasColors([dynamic count, dynamic env]);

  /// A boolean that is always `true` for this stream.
  external bool get isTTY;

  /// Moves this stream's cursor relative to its current position.
  ///
  /// Returns `false` if the stream wishes for the calling code to wait for
  /// the 'drain' event to be emitted before continuing to write additional
  /// data; otherwise `true`.
  ///
  /// Optional [callback] function is invoked once the operation completes.
  external bool moveCursor(num dx, num dy, [void Function() callback]);

  /// A number specifying the number of rows the TTY currently has.
  ///
  /// This property is updated whenever the 'resize' event is emitted.
  external int get rows;
}
