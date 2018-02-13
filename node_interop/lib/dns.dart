// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library node_interop.dns;

import 'package:js/js.dart';
import 'node.dart';
import 'util.dart';

DNS get dns => _dns ??= require('dns');
DNS _dns;

/// Main entry point to Node's "dns" module functionality.
///
/// Instead of using this class directly consider [dns] object.
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
@anonymous
abstract class DNS implements Resolver {
  /// Constructor for DNS [Resolver] class.
  ///
  /// See also:
  /// - [createDNSResolver] helper function.
  external Function get Resolver;

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
  external void lookup(
      String hostname, DNSLookupOptions options, Function callback);
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

Resolver createDNSResolver() {
  return callConstructor(dns.Resolver, null);
}

@JS()
@anonymous
abstract class Resolver {
  external List<String> getServers();
  external void setServers(List<String> servers);
}
