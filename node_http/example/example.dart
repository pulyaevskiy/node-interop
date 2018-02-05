import 'package:node_http/node_http.dart' as http;

main() async {
  // For one-off requests.
  await http.get('https://example.com/');
  // To re-use socket connections:
  final client = new http.NodeClient();
  await client.get('https://example.com/');
  client.close(); // make sure to close the client when work is done.
}
