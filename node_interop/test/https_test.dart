// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@TestOn('node')

import 'package:node_interop/https.dart';
import 'package:test/test.dart';

void main() {
  group('HTTPS', () {
    test('createHttpsAgent', () {
      final options = HttpsAgentOptions(keepAlive: true);
      final agent = createHttpsAgent(options);
      expect(agent, const TypeMatcher<HttpsAgent>());
    });
  });
}
