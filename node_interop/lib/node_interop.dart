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

/// The module-scoped [`require()` function].
///
/// [`require()` function]: https://nodejs.org/api/modules.html#requireid
external T require<T extends JSAny?>(String id);
