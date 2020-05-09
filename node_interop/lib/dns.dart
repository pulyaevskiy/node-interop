// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "dns" module bindings.
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
///     import 'package:node_interop/dns.dart';
///
///     void main() {
///       var options = new DNSLookupOptions(all: true, verbatim: true);
///       void lookupHandler(error, List<DNSAddress> addresses) {
///         console.log(addresses);
///       }
///       dns.lookup('google.com', options, allowInterop(lookupHandler));
///     }
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
@anonymous
abstract class DNSAddress {
  external String get address;
  external num get family;
}

Resolver createDNSResolver() {
  return callConstructor(dns.Resolver, null);
}

/// An independent resolver for DNS requests.
///
/// Note that creating a new resolver uses the default server settings.
/// Setting the servers used for a resolver using [setServers] does not
/// affect other resolvers.
@JS()
@anonymous
abstract class Resolver {
  external void resolve(String hostname, String rrtype,
      void Function(dynamic error, dynamic records) callback);
  external void resolve4(String hostname, optionsOrCallback,
      [void Function(dynamic error, dynamic addresses) callback]);
  external void resolve6(String hostname, optionsOrCallback,
      [void Function(dynamic error, dynamic addresses) callback]);
  external void resolveAny(
      String hostname, void Function(dynamic error, List ret) callback);
  external void resolveCname(
      String hostname, void Function(dynamic error, List<String> ret) callback);
  external void resolveMx(
      String hostname, void Function(dynamic error, List addresses) callback);
  external void resolveNaptr(
      String hostname, void Function(dynamic error, List addresses) callback);
  external void resolveNs(String hostname,
      void Function(dynamic error, List<String> addresses) callback);
  external void resolvePtr(String hostname,
      void Function(dynamic error, List<String> addresses) callback);
  external void resolveSoa(
      String hostname, void Function(dynamic error, dynamic address) callback);
  external void resolveSrv(
      String hostname, void Function(dynamic error, List addresses) callback);
  external void resolveTxt(String hostname,
      void Function(dynamic error, List<List<String>> records) callback);
  external void reverse(
      String ip, void Function(dynamic error, List<String> hostnames) callback);
  external List<String> getServers();
  external void setServers(List<String> servers);
  external void cancel();
}
