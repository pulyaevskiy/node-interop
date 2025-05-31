// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'src/stream/module.dart';

export 'src/stream/duplex.dart' hide NewDuplexOptions;
export 'src/stream/module.dart'
    hide streamPromises, FinishedOptions, StreamPromisesModule;
export 'src/stream/pass_through.dart';
export 'src/stream/stream.dart';
export 'src/stream/readable.dart';
export 'src/stream/transform.dart';
export 'src/stream/writable.dart';

/// The Node.js [`stream` module].
///
/// [`stream` module]: https://nodejs.org/docs/latest/api/events.html#stream
external StreamModule get stream;
