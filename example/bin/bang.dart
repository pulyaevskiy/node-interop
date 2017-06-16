// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:node_interop/node_interop.dart';

/// A module which exports a bang function.
main() {
  exports.setProperty('bang', bang);
}

String bang(String value) {
  return value.toUpperCase() + '!';
}
