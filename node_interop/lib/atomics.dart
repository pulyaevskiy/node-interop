// Copyright (c) 2020, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Bindings for the Atomics JavaScript obect. Since this object only has static
/// methods, it's exposed as a module so that it can be used in the standard
/// Dart style.
@JS()
library node_interop.atomics;

import 'package:js/js.dart';

@JS('Atomics.add')
external int add(List<int> typedArray, int index, int value);

@JS('Atomics.and')
external int and(List<int> typedArray, int index, int value);

@JS('Atomics.compareExchange')
external int compareExchange(
    List<int> typedArray, int index, int expectedValue, int replacementValue);

@JS('Atomics.exchange')
external int exchange(List<int> typedArray, int index, int value);

@JS('Atomics.isLockFree')
external bool isLockFree(int size);

@JS('Atomics.load')
external int load(List<int> typedArray, int index);

@JS('Atomics.notify')
external int notify(List<int> typedArray, int index, [int count]);

@JS('Atomics.or')
external int or(List<int> typedArray, int index, int value);

@JS('Atomics.store')
external int store(List<int> typedArray, int index, int value);

@JS('Atomics.sub')
external int sub(List<int> typedArray, int index, int value);

@JS('Atomics.wait')
external String wait(List<int> typedArray, int index, int value, [num timeout]);

@JS('Atomics.xor')
external int xor(List<int> typedArray, int index, int value);
