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
  <my_package_name>: # Replace this with your package name.
    sources:
      - "node/**"
      - "test/**"
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

If you would like to opt into `dart2js` you will need to add a `build.yaml`
file, which should look roughly like the following:

```yaml
targets:
  <my_package_name>: # Replace this with your package name.
    sources:
      - "node/**"
      - "test/**"
    builders:
      build_node_compilers|entrypoint:
        options:
          compiler: dart2js
          # List any dart2js specific args here, or omit it.
          dart2js_args:
          - --checked
```

As an alternative, `build_runner` supports overriding builder options in 
command line arguments since version `0.7.9` with new `--define` argument.

Overriding compiler to use `dart2js` would look something like this:

```bash
pub run build_runner build \
  --define="build_node_compilers|entrypoint=compiler=dart2js" \
  --output=build/
```


[development dependency]: https://www.dartlang.org/tools/pub/dependencies#dev-dependencies

