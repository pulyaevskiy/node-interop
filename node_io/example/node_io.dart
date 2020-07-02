import 'package:node_io/node_io.dart';

void main() {
  print(Directory.current);
  print('Current directory exists: ${Directory.current.existsSync()}');
  print('Current directory contents: ');
  Directory.current.list().listen(print);

  stderr.writeln('This is error');
}
