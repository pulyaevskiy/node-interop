// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
library node_interop.bindings.dns;

import 'package:js/js.dart';

/// Main entry point to Node's "dns" module functionality.
///
/// Usage:
///
///     DNS dns = require('dns');
///     var options = new DNSLookupOptions(all: true, verbatim: true);
///     void lookupHandler(error, List<DNSAddress> addresses) {
///       console.log(addresses);
///     }
///     dns.lookup('google.com', options, allowInterop(lookupHandler));
@JS()
abstract class DNS {
  /// Resolves a hostname (e.g. 'nodejs.org') into the first found IPv4 or
  /// IPv6 record.
  ///
  /// If `options.verbatim` is `true` then results are returned in the order
  /// the DNS resolver returned them.
  ///
  /// [callback]'s signature depends on the value of `options.all`.
  ///
  /// See also:
  ///   - [https://nodejs.org/api/dns.html#dns_dns_lookup_hostname_options_callback](https://nodejs.org/api/dns.html#dns_dns_lookup_hostname_options_callback)
  external lookup(String hostname, DNSLookupOptions options,
      Function callback);
}

@JS()
@anonymous
abstract class DNSLookupOptions {
  external num get family;
  external bool get all;
  external bool get verbatim;
  external factory DNSLookupOptions({num family, bool all, bool verbatim});
}

@JS()
abstract class DNSAddress {
  external String get address;
  external num get family;
}
