// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'node_interop.dart';
import 'src/tty/module.dart';

export 'src/tty/maybe_tty_readable.dart';
export 'src/tty/maybe_tty_writable.dart';
export 'src/tty/read_stream.dart';
export 'src/tty/write_stream.dart';

/// The Node.js [text terminal module].
///
/// [text terminal module]: https://nodejs.org/docs/latest/api/tty.html
final TtyModule tty = require('tty');
