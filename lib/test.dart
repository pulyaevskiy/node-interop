library node_interop.test;

import 'dart:convert';

import 'bindings.dart';
import 'fs.dart';
import 'node_interop.dart';

/// Installs specified NodeJS [modules] in the same directory with compiled
/// test file. Should normally be used as a very first command in the `main()`
/// function of a test file.
///
/// This function creates 'package.json' with [modules] added to 'dependencies'
/// section and runs `npm install`.
void installNodeModules(Map<String, String> modules) {
  var fs = new NodeFileSystem();
  var platform = new NodePlatform();
  var segments = platform.script.pathSegments.toList();
  var cwd = fs.path.dirname(platform.script.path);
  segments
    ..removeLast()
    ..add('package.json');
  var jsFilepath = fs.path.separator + fs.path.joinAll(segments);
  var file = fs.file(jsFilepath);
  var packages = {
    "name": "test",
    "description": "Test",
    "dependencies": modules,
    "private": true
  };
  file.writeAsStringSync(JSON.encode(packages));

  ChildProcessModule childProcess = require('child_process');
  childProcess.execSync('npm install', new ExecOptions(cwd: cwd));
}
