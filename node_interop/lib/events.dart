// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'node_interop.dart';
import 'src/events/module.dart';

export 'src/events/abort_signal.dart';
export 'src/events/event_emitter.dart';
export 'src/events/event_target.dart';
export 'src/events/module.dart' hide OnOptions, OnceOptions;
export 'src/events/node_event_target.dart';

/// The Node.js [`events` module].
///
/// [`events` module]: https://nodejs.org/docs/latest/api/events.html#events
final events = require<EventsModule>('node:events');
