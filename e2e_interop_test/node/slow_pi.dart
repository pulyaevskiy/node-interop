import 'package:js/js.dart';
import 'package:node_interop/node.dart';
import 'package:node_interop/util.dart';

/// A library which slowly calculates value of π.
void main() {
  setExport('slowPi', allowInterop(slowPi));
  setExport('config', jsify({'defaultAccuracy': 100}));
  setExport('fastPi', 3.1514934010709914);
}

/// Calculates value of π according to specified [accuracy].
double slowPi(int accuracy) {
  double pi = 4.0;
  double top = 4.0;
  double bottom = 3.0;
  bool add = false;
  for (int i = 0; i < accuracy; i++) {
    double value = top / bottom;
    pi = add ? pi + value : pi - value;
    add = !add;
    bottom += 2;
  }
  return pi;
}
