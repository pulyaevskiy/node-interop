import 'package:node_interop/fs.dart';
import 'package:test/test.dart';

void main() {
  group('NodeFileSystem', () {
    var fs = new NodeFileSystem();
    test('current directory', () {
      expect(fs.currentDirectory, new isInstanceOf<Directory>());
      expect(fs.currentDirectory.existsSync(), isTrue);
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
