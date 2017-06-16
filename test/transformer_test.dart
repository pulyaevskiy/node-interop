import 'package:barback/barback.dart';
import 'package:node_interop/transformer.dart';
import 'package:test/test.dart';

void main() {
  test('tranformer default config', () {
    var settings = new BarbackSettings({}, BarbackMode.RELEASE);
    var transformer = new NodePreambleTransformer.asPlugin(settings);
    expect(
        transformer.isPrimary(new AssetId('node_interop', 'bin/main.dart.js')),
        completion(isTrue));
    expect(
        transformer.isPrimary(new AssetId('node_interop', 'lib/main.dart.js')),
        completion(isFalse));
    expect(
        transformer.isPrimary(new AssetId('node_interop', 'bin/other.dart.js')),
        completion(isTrue));
    expect(transformer.isPrimary(new AssetId('node_interop', 'bin/other.js')),
        completion(isFalse));
  });

  test('tranformer includes config', () {
    var settings =
        new BarbackSettings({'include': 'bin/index.dart'}, BarbackMode.RELEASE);
    var transformer = new NodePreambleTransformer.asPlugin(settings);
    expect(
        transformer.isPrimary(new AssetId('node_interop', 'bin/main.dart.js')),
        completion(isFalse));
    expect(
        transformer.isPrimary(new AssetId('node_interop', 'bin/index.dart.js')),
        completion(isTrue));
  });

  test('tranformer excludes config', () {
    var settings =
        new BarbackSettings({'exclude': 'bin/index.dart'}, BarbackMode.RELEASE);
    var transformer = new NodePreambleTransformer.asPlugin(settings);
    expect(transformer.isPrimary(new AssetId('node_interop', 'bin/main.dart')),
        completion(isTrue));
    expect(transformer.isPrimary(new AssetId('node_interop', 'bin/index.dart')),
        completion(isFalse));
  });
}
