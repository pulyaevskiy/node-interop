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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/pulyaevskiy/node-http/issues
