import 'package:node_interop/fs.dart';
import 'package:test/test.dart';
import 'package:node_interop/src/bindings/fs.dart';
import 'package:node_interop/src/bindings/process.dart';

void main() {
  group('NodeFileSystem', () {
    var fs = new NodeFileSystem();
    test('current directory', () {
      print(process.cwd());
      print(nodeFS.statSync(process.cwd()));
      expect(fs.currentDirectory, new isInstanceOf<Directory>());
      expect(fs.currentDirectory.path, isNotEmpty);
      expect(fs.currentDirectory.existsSync(), isTrue,
          reason: 'Path: ${fs.currentDirectory.path} existsSync failed.');
      expect(fs.currentDirectory.exists(), completion(isTrue));
      expect(fs.currentDirectory.isAbsolute, isTrue);
    });

    test('Directory', () {
      expect(fs.currentDirectory, new isInstanceOf<Directory>());
      expect(fs.currentDirectory.existsSync(), isTrue);
      expect(fs.currentDirectory.exists(), completion(isTrue));
      expect(fs.currentDirectory.isAbsolute, isTrue);
    });
  });
}
