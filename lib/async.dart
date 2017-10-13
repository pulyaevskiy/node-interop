// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Dart-flavored asynchronous features of NodeJS.
///
/// This library provides implementations of [ReadableStream] and
/// [WritableStream] which are convenience wrappers around Node's `Readable`
/// and `Writable` streams.
///
/// [ReadableStream] implements regular Dart [Stream] and [WritableStream]
/// implements [StreamSink].
///
/// See also:
///   - [NodeJS streams documentation](https://nodejs.org/api/stream.html)
library node_interop.async;

import 'dart:async';

import 'src/streams.dart';

export 'src/streams.dart';
