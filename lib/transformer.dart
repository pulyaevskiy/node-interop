import 'dart:async';
import 'package:barback/barback.dart';

class NodePreambleTransformer extends Transformer {
  final BarbackSettings settings;
  NodePreambleTransformer.asPlugin(this.settings);

  Future<bool> isPrimary(AssetId id) {
    return new Future.value(id.path.startsWith('bin/main.dart'));
  }

  @override
  apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var id = transform.primaryInput.id;
    var newContent = _preamble + content;
    transform.addOutput(new Asset.fromString(id, newContent));
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
