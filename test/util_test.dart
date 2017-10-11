// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
@TestOn('node')
library node_interop.util_test;

import 'package:js/js.dart';
import 'package:node_interop/test.dart';
import 'package:test/test.dart';

const fixturesJS = '''
function Apple() {
  this.color = "red";
  this.origin = "Japan";
}
Apple.prototype.grow = function() {};

exports.stringVal = "node";
exports.numVal = 3.1415;
exports.boolVal = true;
exports.nullVal = null;
exports.pojoVal = {"propKey": "propValue"};
exports.arrayVal = [1, "two"];
exports.funcVal = function () {
  return true;
};
exports.objectVal = new Apple();
''';

@JS()
abstract class Fixtures {
  external dynamic get stringVal;
  external dynamic get numVal;
  external dynamic get boolVal;
  external dynamic get nullVal;
  external dynamic get pojoVal;
  external dynamic get arrayVal;
  external dynamic get funcVal;
  external dynamic get objectVal;
}

void main() {
  createJSFile('fixtures.js', fixturesJS);

  group('dartify', () {
    test('it handles js primitives', () {
      final Fixtures js = require('./fixtures.js');
      expect(dartify(js.stringVal), "node");
      expect(dartify(js.numVal), 3.1415);
      expect(dartify(js.boolVal), isTrue);
      expect(dartify(js.nullVal), isNull);
    });

    test('it handles POJOs', () {
      final Fixtures js = require('./fixtures.js');
      expect(dartify(js.pojoVal), {"propKey": "propValue"});
    });

    test('it handles arrays', () {
      final Fixtures js = require('./fixtures.js');
      expect(dartify(js.arrayVal), [1, "two"]);
    });

    test('it does not handle functions', () {
      final Fixtures js = require('./fixtures.js');
      expect(() {
        dartify(js.funcVal);
      }, throwsA(new isInstanceOf<AssertionError>()));
    });

    test('it handles objects with prototypes', () {
      final Fixtures js = require('./fixtures.js');
      expect(dartify(js.objectVal), {'color': 'red', 'origin': 'Japan'});
    });
  });
}
