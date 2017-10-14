// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for Dart-style asynchronous programming with NodeJS streams.
///
/// ## ReadableStream
///
/// Wraps around Node's [Readable] stream and implements standard [Stream]
/// interface.
///
/// ## WritableStream
///
/// Wraps around Node's [Writable] stream and implements standard [StreamSink]
/// interface.
///
/// ## NodeIOSink
///
/// Subclass of [WritableStream] which allows writing binary data and strings
/// in to NodeJS target IO stream.
///
/// See also:
///   - [NodeJS streams documentation](https://nodejs.org/api/stream.html)
///   - [Async programming with Dart streams](https://www.dartlang.org/tutorials/language/streams)
///   - [Dart streams documentation](https://api.dartlang.org/stable/1.24.2/dart-async/dart-async-library.html)
library node_interop.async;

import 'dart:async';
import 'src/bindings/stream.dart';

import 'src/streams.dart';

export 'src/streams.dart';
