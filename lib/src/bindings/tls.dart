// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.tls;

import 'package:js/js.dart';
import 'net.dart';

@JS()
abstract class TlsServer extends NetServer {}

@JS()
@anonymous
abstract class TlsServerOptions {}
