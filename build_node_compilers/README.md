# build_node_compilers

This library provides builders for compiling Dart code to Node-compatible 
JavaScript modules. Both `dartdevc` and `dart2js` compilers are supported.

## Installation

This package is intended to be used as a [development dependency][] for users
of `node_interop` libraries. Simply add the following to your `pubspec.yaml`:

```yaml
dev_dependencies:
  build_runner: # needed to run the build
  build_node_compilers:
```

## Configuration

Create `build.yaml` file in your project with following contents:

```yaml
targets:
  $default:
    sources:
      - "node/**"
      - "test/**" # Include this if use want to compile tests.
      - "example/**" # Include this if you have examples.
```

The above is a required minimum. To build your project run following:

```bash
pub run build_runner build --output=build/
```

> Note that for projects using node_interop packages
> the convention is to put main application files (Dart files
> containing `main` function) in the top-level `node/` directory.
> (This is to avoid confusion with apps targeting browsers in `web/` and package-
> level binaries in `bin/` recognized by Pub).

By default, the `dartdevc` compiler is used, which is the Dart Development
Compiler.

If you would like to opt into `dart2js` you will need to override `compiler`
option which would look something like this:

```bash
pub run build_runner build \
  --define="build_node_compilers|entrypoint=compiler=dart2js" \
  --output=build/
```

[development dependency]: https://www.dartlang.org/tools/pub/dependencies#dev-dependencies

