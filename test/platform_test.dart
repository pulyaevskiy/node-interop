@TestOn('node')
import 'package:node_interop/node_interop.dart';
import 'package:test/test.dart';
import 'package:node_interop/src/bindings/os.dart';
import 'package:node_interop/src/bindings/globals.dart';
import 'package:node_interop/src/bindings/process.dart';

void main() {
  group('Platform', () {
    const platform = const NodePlatform();

    test('environment', () {
      expect(platform.environment, isMap);
      expect(platform.environment, isNotEmpty);
      expect(platform.environment, contains('PATH'));
    });

    test('script', () {
      expect(platform.script, new isInstanceOf<Uri>());
      expect(platform.script.isAbsolute, isTrue);
      expect(platform.script.path, filename);
      expect(platform.script.pathSegments.last,
          'platform_test.dart.node_test.dart.js');
    });

    test('executable', () {
      expect(platform.executable, 'node');
      expect(platform.executable, process.argv0);
    });

    test('executableArguments', () {
      expect(platform.executableArguments, isList);
      expect(platform.executableArguments, process.execArgv);
    });

    test('unsupported platforms', () {
      expect(platform.isAndroid, isFalse);
      expect(platform.isFuchsia, isFalse);
      expect(platform.isIOS, isFalse);
    });

    test('isMacOS', () {
      expect(platform.isMacOS, isTrue);
      expect(platform.isLinux, isFalse);
      expect(platform.isWindows, isFalse);
    }, testOn: 'mac-os');

    test('isLinux', () {
      expect(platform.isMacOS, isFalse);
      expect(platform.isLinux, isTrue);
      expect(platform.isWindows, isFalse);
    }, testOn: 'linux');

    test('isWindows', () {
      expect(platform.isMacOS, isFalse);
      expect(platform.isLinux, isFalse);
      expect(platform.isWindows, isTrue);
    }, testOn: 'windows');

    test('localHostname', () {
      expect(platform.localHostname, os.hostname());
      expect(platform.localHostname, isNotEmpty);
    });

    test('numberOfProcessors', () {
      expect(platform.numberOfProcessors, os.cpus().length);
      expect(platform.numberOfProcessors, greaterThanOrEqualTo(1));
    });

    test('operatingSystem', () {
      expect(platform.operatingSystem, process.platform);
      expect(platform.operatingSystem, isNotEmpty);
    });

    test('packageConfig', () {
      expect(() {
        platform.packageConfig;
      }, throwsA(new isInstanceOf<UnsupportedError>()));
    });

    test('packageRoot', () {
      expect(() {
        platform.packageRoot;
      }, throwsA(new isInstanceOf<UnsupportedError>()));
    });

    test('pathSeparator', () {
      if (platform.isWindows) {
        expect(platform.pathSeparator, '\\');
      } else {
        expect(platform.pathSeparator, '/');
      }
    });

    test('resolvedExecutable', () {
      expect(platform.resolvedExecutable, process.execPath);
      expect(platform.resolvedExecutable, isNotEmpty);
    });

    test('script', () {
      expect(platform.script, new isInstanceOf<Uri>());
      expect(platform.script.path, filename);
    });

    test('stdinSupportsAnsi', () {
      expect(() {
        platform.stdinSupportsAnsi;
      }, throwsA(new isInstanceOf<UnimplementedError>()));
    });

    test('stdoutSupportsAnsi', () {
      expect(() {
        platform.stdoutSupportsAnsi;
      }, throwsA(new isInstanceOf<UnimplementedError>()));
    });

    test('toJson', () {
      expect(() {
        platform.toJson();
      }, throwsA(new isInstanceOf<UnimplementedError>()));
    });

    test('toJson', () {
      expect(() {
        platform.version;
      }, throwsA(new isInstanceOf<UnsupportedError>()));
    });

    test('localeName', () {
      expect(() {
        platform.localeName;
      }, throwsA(new isInstanceOf<UnimplementedError>()));
    });
  });
}
