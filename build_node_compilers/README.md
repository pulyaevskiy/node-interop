# build_node_compilers

DDC and dart2js builders to use with `build_runner` for compiling to Node.

## Installation

This package is intended to be used as a [development dependency][] for users
of [`package:build`][] who want to run code in a Node. Simply add the
following to your `pubspec.yaml`:

```yaml
dev_dependencies:
  build_node_compilers:
```

## Configuration

By default, the `dartdevc` compiler will be used, which is the Dart Development
Compiler.

If you would like to opt into `dart2js` you will need to add a `build.yaml`
file, which should look roughly like the following:

```yaml
targets:
  <my-package>: # Replace this with  your package name.
    builders:
      build_node_compilers|entrypoint:
        # These are globs for the entrypoints you want to compile.
        generate_for:
        - test/**_test.dart
        - node/**.dart
        options:
          compiler: dart2js
          # List any dart2js specific args here, or omit it.
          dart2js_args:
          - --checked
```

[development dependency]: https://www.dartlang.org/tools/pub/dependencies#dev-dependencies
[`package:build`]: https://pub.dartlang.org/packages/build
