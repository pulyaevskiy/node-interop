library node_interop.test;

import 'dart:convert';

import 'fs.dart';
import 'node_interop.dart';

export 'node_interop.dart';

/// Creates arbitrary file in the same directory with the compiled test file.
///
/// This is useful for creating native Node modules for testing interactions
/// between Dart and JS.
///
/// Returns absolute path to the created file.
///
/// Example test case:
///
///     @JS()
///     @TestOn('node')
///     library pi_test;
///
///     import 'package:node_interop/test.dart';
///     import 'package:test/test.dart';
///     import 'package:js/js.dart';
///
///     /// Simple JS module which exports one value.
///     const fixtureJS = '''
///     exports.simplePI = 3.1415;
///     '''
///
///     @JS()
///     abstract class Fixture {
///       external num get simplePI;
///     }
///
///     void main() {
///       createFile('fixture.js', fixtureJS);
///
///       test('simple PI', function() {
///         Fixture fixture = require('./fixture.js');
///         expect(fixture.simplePI, 3.1415);
///       });
///     }
String createFile(String name, String contents) {
  var fs = new NodeFileSystem();
  var segments = node.platform.script.pathSegments.toList();
  segments
    ..removeLast()
    ..add(name);
  var jsFilepath = fs.path.separator + fs.path.joinAll(segments);
  var file = fs.file(jsFilepath);
  file.writeAsStringSync(contents);
  return jsFilepath;
}

@Deprecated('Use createFile() instead.')
void createJSFile(String name, String contents) => createFile(name, contents);

/// Installs specified NodeJS [modules] in the same directory with compiled
/// test file. Should normally be used as a very first command in the `main()`
/// function of a test file.
///
/// This function creates 'package.json' with [modules] added to 'dependencies'
/// section and runs `npm install`.
void installNodeModules(Map<String, String> modules) {
  var fs = new NodeFileSystem();
  var segments = node.platform.script.pathSegments.toList();
  var cwd = fs.path.dirname(node.platform.script.path);
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
