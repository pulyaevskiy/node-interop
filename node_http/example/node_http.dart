import 'package:node_http/node_http.dart' as http;

void main() async {
  // For one-off requests.
  final response = await http.get(Uri.parse('https://example.com/'));
  print(response.body);
  // To re-use socket connections:
  final client = http.NodeClient();
  final response2 = await client.get(Uri.parse('https://example.com/'));
  print(response2.body);
  client.close(); // make sure to close the client when work is done.
}
