@JS()
library promises;

import 'dart:async';
import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';

main() async {
  final AsyncFoos foos = require('./promises.js');
  var promise = foos.asyncFoo();
  print(promise);
  var future = jsPromiseToFuture(promise);
  await future.then((value) {
    print('Future completed: $value');
  });

  var f2 = new Future.delayed(
      new Duration(milliseconds: 1500), () => 'Delayed future result!');
  var p2 = futureToJsPromise(f2);
  print(p2);
  var p3 = foos.receiveFoo(p2);

  p3.then(allowInterop((value) {
    print('Got result: $value');
  }));
}

@JS()
@anonymous
abstract class AsyncFoos {
  external JsPromise asyncFoo();
  external JsPromise receiveFoo(promise);
  external unwrapPromise(promise);
}
