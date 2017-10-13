// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@JS()
@TestOn('node')
library test_util_test;

import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';
import 'package:node_interop/test.dart';
import 'package:test/test.dart';

void main() {
  installNodeModules({'express': '~4.16.0'});

  group('Test utilities', () {
    test('installNodeModules()', () {
      var express = require('express');
      expect(express, isNotNull);

      expect(() {
        require('no-such-module');
      }, throwsA(new isInstanceOf<JsError>()));
    });
  });
}

@JS('Error')
abstract class JsError {
  external String get code;
  external String get message;
  external String get stack;
}
