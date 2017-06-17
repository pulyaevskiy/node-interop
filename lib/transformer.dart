import 'dart:async';
import 'package:barback/barback.dart';
import 'package:glob/glob.dart';

class NodePreambleTransformer extends Transformer {
  final BarbackSettings settings;
  NodePreambleTransformer.asPlugin(this.settings);

  String get allowedExtensions => ".dart.js";

  FutureOr<bool> isPrimary(AssetId id) {
    var includes = settings.configuration['include'];
    if (includes is String) {
      var glob = new Glob(includes);
      return new Future.value(glob.matches(id.path));
    }
    var excludes = settings.configuration['exclude'];
    if (excludes is String) {
      var glob = new Glob(excludes);
      return new Future.value(!glob.matches(id.path));
    }
    // By default take all Dart files from `bin/` and `node_test/`.
    return new Future.value(
        (id.path.startsWith('bin/') || id.path.startsWith('node_test/')) &&
            id.path.endsWith(allowedExtensions));
  }

  @override
  apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var id = transform.primaryInput.id;
    var newContent = _preamble + content;
    transform.addOutput(new Asset.fromString(id, newContent));
    print('Added preamble to $id');
  }
}

const String _preamble = r'''
var self = Object.create(global);

// TODO: This isn't really a correct transformation. For example, it will fail
// for paths that contain characters that need to be escaped in URLs. Once
// dart-lang/sdk#27979 is fixed, it should be possible to make it better.
self.location = {
    href: "file://" + (function () {
        var cwd = process.cwd();
        if (process.platform != "win32") return cwd;
        return "/" + cwd.replace("\\", "/");
    })() + "/"
};

self.scheduleImmediate = setImmediate;
self.require = require;
self.exports = exports;
self.process = process;
self.__dirname = __dirname;
self.__filename = __filename;

(function () {
    function computeCurrentScript() {
        try {
            throw new Error();
        } catch (e) {
            var stack = e.stack;
            var re = new RegExp("^ *at [^(]*\\((.*):[0-9]*:[0-9]*\\)$", "mg");
            var lastMatch = null;
            do {
                var match = re.exec(stack);
                if (match != null) lastMatch = match;
            } while (match != null);
            return lastMatch[1];
        }
    }

    var cachedCurrentScript = null;
    self.document = {
        get currentScript() {
            if (cachedCurrentScript == null) {
                cachedCurrentScript = { src: computeCurrentScript() };
            }
            return cachedCurrentScript;
        }
    };
})();

self.dartDeferredLibraryLoader = function (uri, successCallback, errorCallback) {
    try {
        load(uri);
        successCallback();
    } catch (error) {
        errorCallback(error);
    }
};

''';
