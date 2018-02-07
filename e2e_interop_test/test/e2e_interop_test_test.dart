@TestOn('vm')
import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('Hello world', () {
    setUp(() {
      final result = Process
          .runSync('pub', ['run', 'build_runner', 'build', '--output=build/']);
      expect(result.exitCode, 0);
    });

    test('compile with DDC', () {
      final result =
          Process.runSync('node', ['build/node/hello_world.dart.js']);
      expect(result.stdout, 'Hello world\n');
    });
  });
}
