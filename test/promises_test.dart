// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
@TestOn('node')
library promises_test;

import 'dart:async';
import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';
import 'package:node_interop/fs.dart';
import 'package:test/test.dart';

const promisesJS = '''
exports.createPromise = function (value) {
    var promise = new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(value);
        });
    });
    return promise;
};
exports.receivePromise = function (promise) {
    return promise.then((value) => {
        return value.repeat(3);
    }, (error) => {
        throw error.repeat(3);
    });
}
''';

void main() {
  setUpAll(() {
    var fs = new NodeFileSystem();
    var platform = new NodePlatform();
    var segments = platform.script.pathSegments.toList();
    segments
      ..removeLast()
      ..add('promises.js');
    var jsFilepath = fs.path.separator + fs.path.joinAll(segments);
    var file = fs.file(jsFilepath);
    file.writeAsStringSync(promisesJS);
  });

  test('jsPromiseToFuture', () async {
    final JsPromises js = require('./promises.js');
    JsPromise promise = js.createPromise('Futures are better than Promises');
    Future future = jsPromiseToFuture(promise);
    expect(future, completion('Futures are better than Promises'));
  });

  test('futureToJsPromise', () {
    final JsPromises js = require('./promises.js');
    var future = new Future.value('Yes');
    var promise = futureToJsPromise(future);
    var promise2 = js.receivePromise(promise);
    expect(jsPromiseToFuture(promise2), completion('YesYesYes'));
  });

  test('create promise in Dart', () {
    final JsPromises js = require('./promises.js');
    var promise = new JsPromise(allowInterop((resolve, reject) {
      resolve('Yas');
    }));
    var promise2 = js.receivePromise(promise);
    expect(jsPromiseToFuture(promise2), completion('YasYasYas'));
  });

  test('reject a Promise', () {
    var promise = new JsPromise(allowInterop((resolve, reject) {
      reject('No');
    }));
    expect(jsPromiseToFuture(promise), throwsA('No'));
  });

  test('reject a Future', () {
    final JsPromises js = require('./promises.js');
    var future = new Future.error('No');
    var promise = futureToJsPromise(future);
    var promise2 = js.receivePromise(promise);
    expect(jsPromiseToFuture(promise2), throwsA('NoNoNo'));
  });
}

@JS()
@anonymous
abstract class JsPromises {
  external JsPromise createPromise(value);
  external JsPromise receivePromise(promise);
}
