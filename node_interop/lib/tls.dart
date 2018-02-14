// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node TLS module bindings.
@JS()
library node_interop.tls;

import 'package:js/js.dart';

import 'net.dart';

@JS()
@anonymous
abstract class TlsServer extends NetServer {}

@JS()
@anonymous
abstract class TlsServerOptions {}
