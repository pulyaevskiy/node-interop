// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Testing utilities for Dart applications with node_interop.
@JS()
library node_interop.test;

import 'dart:convert';

import 'package:js/js.dart';

import 'child_process.dart';
import 'fs.dart';
import 'node.dart';
import 'path.dart';

/// Creates arbitrary file in the same directory with the compiled test file.
///
/// This is useful for creating native Node modules (as well as any other
/// fixtures) for testing interactions between Dart and JS.
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
  String script = process.argv[1];
  var segments = script.split(path.sep);
  segments
    ..removeLast()
    ..add(name);
  var jsFilepath = path.sep + segments.join(path.sep);
  fs.writeFileSync(jsFilepath, contents);
  return jsFilepath;
}

/// Installs specified NodeJS [modules] in the same directory with compiled
/// test file. Should normally be used as a very first command in the `main()`
/// function of a test file.
///
/// This function creates 'package.json' with [modules] added to 'dependencies'
/// section and runs `npm install`.
void installNodeModules(Map<String, String> modules) {
  String script = process.argv[1];
  var segments = script.split(path.sep);

  var cwd = path.dirname(script);
  segments
    ..removeLast()
    ..add('package.json');
  var jsFilepath = path.sep + segments.join(path.sep);
  var packages = {
    "name": "test",
    "description": "Test",
    "dependencies": modules,
    "private": true
  };
  fs.writeFileSync(jsFilepath, JSON.encode(packages));
  childProcess.execSync('npm install', new ExecOptions(cwd: cwd));
}
