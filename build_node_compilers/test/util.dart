// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';

/// Forwards to [testBuilder], and adds all output assets to [assets].
Future<Null> testBuilderAndCollectAssets(
    Builder builder, Map<String, Object> assets) async {
  var writer = InMemoryAssetWriter();
  await testBuilder(builder, assets, writer: writer);
  writer.assets.forEach((id, value) {
    assets['${id.package}|${id.path}'] = value;
  });
}
