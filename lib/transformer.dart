// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';

import 'package:barback/barback.dart';
import 'package:glob/glob.dart';
import 'package:node_preamble/preamble.dart';

class NodePreambleTransformer extends Transformer {
  final BarbackSettings settings;
  NodePreambleTransformer.asPlugin(this.settings);

  String get allowedExtensions => ".dart.js";

  FutureOr<bool> isPrimary(AssetId id) {
    var includes = settings.configuration['include'];
    if (includes is String) {
      var glob = new Glob(includes);
      return new Future.value(glob.matches(id.path));
    }
    var excludes = settings.configuration['exclude'];
    if (excludes is String) {
      var glob = new Glob(excludes);
      return new Future.value(!glob.matches(id.path));
    }
    // By default take all Dart files from `bin/` and `node_test/`.
    return new Future.value(
        (id.path.startsWith('bin/') || id.path.startsWith('node_test/')) &&
            id.path.endsWith(allowedExtensions));
  }

  @override
  apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var id = transform.primaryInput.id;
    var preamble = getPreamble();
    var newContent = preamble + content;

    transform.addOutput(new Asset.fromString(id, newContent));
    print('Added preamble to $id');
  }
}
