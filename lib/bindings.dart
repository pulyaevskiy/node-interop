// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Provides bindings to NodeJS APIs.
///
/// Some APIs, like 'fs' and 'http' must be `require`d to use:
///
///     FS nodeFS = require('fs');
///     HTTP nodeHTTP = require('http');
library node_interop.bindings;

export 'src/bindings/events.dart';
export 'src/bindings/fs.dart';
export 'src/bindings/globals.dart';
export 'src/bindings/os.dart';
export 'src/bindings/process.dart';
