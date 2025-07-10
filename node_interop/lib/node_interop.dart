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
/// List<String> contents = fs.readDirSync('/tmp');
/// ```
library;

import 'src/events/module.dart';
import 'src/process/module.dart';
import 'src/stream/module.dart';

export 'src/buffer/array_buffer.dart';
export 'src/buffer/buffer.dart';
export 'src/buffer/file.dart';
export 'src/buffer/module.dart';
export 'src/buffer/typed_array.dart';
export 'src/buffer/uint8array.dart';
export 'src/cjs/module.dart';
export 'src/cjs/require.dart';
export 'src/error/range_error.dart';
export 'src/error/reference_error.dart';
export 'src/error/syntax_error.dart';
export 'src/error/system_error.dart';
export 'src/error/type_error.dart';
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

/// The Node.js [`events` module].
///
/// [`events` module]: https://nodejs.org/docs/latest/api/events.html#events
external EventsModule get events;

/// The Node.js [`process` module].
///
/// [`process` module]: https://nodejs.org/docs/latest/api/process.html
external ProcessModule get process;

/// The Node.js [`stream` module].
///
/// [`stream` module]: https://nodejs.org/docs/latest/api/stream.html
external StreamModule get stream;

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/api/modules.html#__dirname
///
/// This throws a [NodeReferenceError] if the compiled JS file is loaded as an
/// ES6 module.
external String get dirName;

/// See [the Node.js documentation].
///
/// [the Node.js documentation]: https://nodejs.org/api/modules.html#__filename
///
/// This throws a [NodeReferenceError] if the compiled JS file is loaded as an
/// ES6 module.
external String get fileName;
