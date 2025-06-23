// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The core node interop library.
///
/// This library exports only globally available APIs. Built-in Node modules can
/// be imported with `import 'package:node_interop/{moduleName}.dart`, e.g. for
/// the "fs" module:
///
/// ```dart
/// import 'package:node_interop/fs.dart';
///
/// List<String> contents = fs.readdirSync('/tmp');
/// ```
library;

import 'dart:js_interop';

import 'src/events/module.dart';
import 'src/process/module.dart';
import 'src/stream/module.dart';

export 'src/buffer/array_buffer.dart';
export 'src/buffer/buffer.dart';
export 'src/buffer/file.dart';
export 'src/buffer/module.dart';
export 'src/buffer/typed_array.dart';
export 'src/buffer/uint8array.dart';
export 'src/events/abort_signal.dart';
export 'src/events/event_emitter.dart';
export 'src/events/event_target.dart';
export 'src/events/module.dart' hide OnOptions;
export 'src/events/node_event_target.dart';
export 'src/process/ipc_channel.dart';
export 'src/process/module.dart';
export 'src/stream/duplex.dart' hide NewDuplexOptions;
export 'src/stream/module.dart'
    hide streamPromises, FinishedOptions, StreamPromisesModule;
export 'src/stream/pass_through.dart';
export 'src/stream/readable.dart';
export 'src/stream/stream.dart';
export 'src/stream/transform.dart';
export 'src/stream/writable.dart';

/// The module-scoped [`require()` function].
///
/// [`require()` function]: https://nodejs.org/api/modules.html#requireid
@JS()
external T require<T extends JSAny?>(String id);

/// The Node.js [`events` module].
///
/// [`events` module]: https://nodejs.org/docs/latest/api/events.html#events
@JS()
external EventsModule get events;

/// The Node.js [`process` module].
///
/// [`process` module]: https://nodejs.org/docs/latest/api/process.html
@JS()
external ProcessModule get process;

/// The Node.js [`stream` module].
///
/// [`stream` module]: https://nodejs.org/docs/latest/api/stream.html
@JS()
external StreamModule get stream;
