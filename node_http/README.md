# node_http

HTTP client using Node I/O system for Dart.

## Usage

A simple usage example:

```dart
import 'package:node_http/node_http.dart' as http;

main() async {
  // For one-off requests.
  final response1 = await http.get('https://example.com/'); 
  // To re-use socket connections:
  final client = new http.NodeClient();
  final response2 = await client.get('https://example.com/');
}
```

## Configuration and build

Add `build_node_compilers` and `build_runner` to `dev_dependencies` section 
in `pubspec.yaml` of your project:

```yaml
dev_dependencies:
  build_runner: # needed to run the build
  build_node_compilers:
```

Add `build.yaml` file to the root of your project:

```yaml
targets:
  $default:
    sources:
      - "node/**"
      - "test/**" # Include this if you want to compile tests.
      - "example/**" # Include this if you want to compile examples.
```

By convention all Dart files which declare `main` function go in `node/` folder.

To build your project run following:

```bash
pub run build_runner build --output=build/
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/pulyaevskiy/node-http/issues
