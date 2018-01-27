// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node "stream" module bindings.
@JS()
library node_interop.stream;

import 'package:js/js.dart';

import 'events.dart';

@JS()
abstract class Readable extends EventEmitter {
  external bool isPaused();
  external Readable pause();
  external void pipe(Writable destination, [options]);
  external Readable resume();
  external void setEncoding(String encoding);
  external void destroy([error]);
}

@JS()
abstract class Writable extends EventEmitter {
  external bool write(chunk, [encodingOrCallback, callback]);
  external void end([dynamic data, encodingOrCallback, callback]);
  external void setDefaultEncoding(String encoding);
  external Writable destroy([error]);
}
