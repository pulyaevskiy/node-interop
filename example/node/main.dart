// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';

// Examples of using Node bindings directly.
main() async {
  // Require a module:
  DNS dns = require('dns');
  var options = new DNSLookupOptions(all: true, verbatim: true);
  void lookupHandler(error, List<DNSAddress> addresses) {
    console.log(addresses);
  }

  // Make sure to wrap Dart functions with `allowInterop` when passing to
  // JavaScript.
  dns.lookup('google.com', options, allowInterop(lookupHandler));

  // One more module:
  OS os = require('os');
  console.log(os.hostname());
  console.log(os.cpus());
}
