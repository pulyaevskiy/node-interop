// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:js';
import 'dart:typed_data';

import 'package:node_interop/node.dart';
import 'package:node_interop/stream.dart';

abstract class HasReadable {
  Readable get nativeInstance;
}

/// [Stream] wrapper around Node's [Readable] stream.
class ReadableStream<T> extends Stream<T> implements HasReadable {
  /// Native `Readable` instance wrapped by this stream.
  ///
  /// It is not recommended to interact with this object directly.
  @override
  final Readable nativeInstance;
  final Function _convert;
  StreamController<T> _controller;

  /// Creates new [ReadableStream] which wraps [nativeInstance] of `Readable`
  /// type.
  ///
  /// The [convert] hook is called for each element of this stream before it's
  /// send to the listener. This allows implementations to convert raw
  /// JavaScript data in to desired Dart representation. If no convert
  /// function is provided then data is send to the listener unchanged.
  ReadableStream(this.nativeInstance, {T Function(dynamic data) convert})
      : _convert = convert {
    _controller = StreamController(
        onPause: _onPause, onResume: _onResume, onCancel: _onCancel);
    nativeInstance.on('error', allowInterop(_errorHandler));
  }

  void _errorHandler([JsError error]) {
    _controller.addError(error);
  }

  void _onPause() {
    nativeInstance.pause();
  }

  void _onResume() {
    nativeInstance.resume();
  }

  void _onCancel() {
    nativeInstance.removeAllListeners('data');
    nativeInstance.removeAllListeners('end');
    _controller.close();
  }

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    nativeInstance.on('data', allowInterop((chunk) {
      assert(chunk != null);
      var data = (_convert == null) ? chunk : _convert(chunk);
      _controller.add(data);
    }));
    nativeInstance.on('end', allowInterop(() {
      _controller.close();
    }));

    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

/// [StreamSink] wrapper around Node's [Writable] stream.
class WritableStream<S> implements StreamSink<S> {
  /// Native JavaScript Writable wrapped by this stream.
  ///
  /// It is not recommended to interact with this object directly.
  final Writable nativeInstance;
  final Function _convert;

  Completer _drainCompleter;

  /// Creates [WritableStream] which wraps [nativeInstance] of `Writable`
  /// type.
  ///
  /// The [convert] hook is called for each element of this stream sink before
  /// it's added to the [nativeInstance]. This allows implementations to convert
  /// Dart objects in to values accepted by JavaScript streams. If no convert
  /// function is provided then data is sent to target unchanged.
  WritableStream(this.nativeInstance, {dynamic Function(S data) convert})
      : _convert = convert {
    nativeInstance.on('error', allowInterop(_errorHandler));
  }

  void _errorHandler(JsError error) {
    if (_drainCompleter != null && !_drainCompleter.isCompleted) {
      _drainCompleter.completeError(error);
    } else if (_closeCompleter != null && !_closeCompleter.isCompleted) {
      _closeCompleter.completeError(error);
    } else {
      throw error;
    }
  }

  /// Writes [data] to nativeStream.
  void _write(S data) {
    var completer = Completer();
    void _flush([JsError error]) {
      if (completer.isCompleted) return;
      if (error != null) {
        completer.completeError(error);
      } else {
        completer.complete();
      }
    }

    var chunk = (_convert == null) ? data : _convert(data);
    var isFlushed = nativeInstance.write(chunk, allowInterop(_flush));
    if (!isFlushed) {
      // Keep track of the latest unflushed chunk of data.
      _drainCompleter = completer;
    }
  }

  /// Returns Future which completes once all buffered data is accepted by
  /// underlying target.
  ///
  /// If there is no buffered data to drain then returned Future completes in
  /// next event-loop iteration.
  Future get drain {
    if (_drainCompleter != null && !_drainCompleter.isCompleted) {
      return _drainCompleter.future;
    }
    return Future.value();
  }

  @override
  void add(S data) {
    _write(data);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    nativeInstance.emit('error', error);
  }

  @override
  Future addStream(Stream<S> stream) {
    throw UnimplementedError();
  }

  @override
  Future close() {
    if (_closeCompleter != null) return _closeCompleter.future;
    _closeCompleter = Completer();
    void end() {
      if (!_closeCompleter.isCompleted) _closeCompleter.complete();
    }

    nativeInstance.end(allowInterop(end));
    return _closeCompleter.future;
  }

  Completer _closeCompleter;

  @override
  Future get done => close();
}

/// Writable stream of bytes, also accepts `String` values which are encoded
/// with specified [Encoding].
class NodeIOSink extends WritableStream<List<int>> implements IOSink {
  static dynamic _nodeIoSinkConvert(List<int> data) {
    if (data is! Uint8List) {
      data = Uint8List.fromList(data);
    }
    return Buffer.from(data);
  }

  Encoding _encoding;

  NodeIOSink(Writable nativeStream, {Encoding encoding = utf8})
      : super(nativeStream, convert: _nodeIoSinkConvert) {
    _encoding = encoding;
  }

  @override
  Encoding get encoding => _encoding;

  @override
  set encoding(Encoding value) {
    _encoding = value;
  }

  @override
  Future flush() => drain;

  @override
  void write(Object obj) {
    _write(encoding.encode(obj.toString()));
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    var data = objects.map((obj) => obj.toString()).join(separator);
    _write(encoding.encode(data));
  }

  @override
  void writeCharCode(int charCode) {
    _write(encoding.encode(String.fromCharCode(charCode)));
  }

  @override
  void writeln([Object obj = '']) {
    _write(encoding.encode('$obj\n'));
  }
}
