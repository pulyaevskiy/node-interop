// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:platform/platform.dart';

import 'bindings/globals.dart';
import 'bindings/os.dart';
import 'bindings/process.dart';
import 'util.dart';

export 'package:platform/platform.dart' show Platform;

class NodePlatform implements Platform {
  const NodePlatform();

  @override
  Map<String, String> get environment => jsObjectToMap(process.env);

  @override
  String get executable => process.argv0;

  @override
  List<String> get executableArguments => process.execArgv;

  @override
  bool get isAndroid => false;

  @override
  bool get isFuchsia => false;

  @override
  bool get isIOS => false;

  @override
  bool get isLinux => process.platform.startsWith('linux');

  @override
  bool get isMacOS => process.platform.startsWith('darwin');

  @override
  bool get isWindows => process.platform.startsWith('win');

  @override
  String get localHostname => os.hostname();

  @override
  int get numberOfProcessors => os.cpus().length;

  @override
  String get operatingSystem => process.platform;

  @override
  String get packageConfig {
    throw new UnsupportedError(
        'Package config is not supported in Node environment');
  }

  @override
  String get packageRoot {
    throw new UnsupportedError(
        'Package root is not supported in Node environment');
  }

  @override
  String get pathSeparator => isWindows ? '\\' : '/';

  @override
  String get resolvedExecutable => process.execPath;

  @override
  Uri get script => new Uri.file(filename, windows: isWindows);

  @override
  bool get stdinSupportsAnsi => throw new UnimplementedError();

  @override
  bool get stdoutSupportsAnsi => throw new UnimplementedError();

  @override
  String toJson() {
    throw new UnimplementedError();
  }

  @override
  String get version {
    throw new UnsupportedError(
        'Dart version is not supported in Node environment');
  }

  @override
  String get localeName => throw new UnimplementedError();
}
