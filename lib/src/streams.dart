// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:js/js.dart';

import 'bindings/stream.dart' as js;
import 'bindings/globals.dart';

/// [Stream] wrapper around Node's `Readable` stream.
class ReadableStream<T> extends Stream<T> {
  /// Native `Readable` instance wrapped by this stream.
  ///
  /// It is not recommended to interact with this object directly.
  final js.Readable nativeStream;
  final Function _convert;
  StreamController<T> _controller;

  /// Creates new [ReadableStream] which wraps [nativeStream].
  ///
  /// The [convert] hook is called for each element of this stream before it's
  /// send to the listener. This allows implementations to convert raw
  /// JavaScript data in to desired Dart representation, if needed.
  ReadableStream(this.nativeStream, {T convert(dynamic data)}) : _convert = convert {
    _controller = new StreamController(
        onPause: _onPause, onResume: _onResume, onCancel: _onCancel);
    nativeStream.on('error', allowInterop(_errorHandler));
  }

  void _errorHandler(error) {
    _controller.addError(error); // TODO: dartify error
    nativeStream.removeAllListeners('data');
    nativeStream.removeAllListeners('end');
    _controller.close();
  }

  void _onPause() {
    nativeStream.pause();
  }

  void _onResume() {
    nativeStream.resume();
  }

  void _onCancel() {
    nativeStream.removeAllListeners('data');
    nativeStream.removeAllListeners('end');
    _controller.close();
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    nativeStream.on('data', allowInterop((T chunk) {
      var data = (_convert == null) ? chunk : _convert(chunk);
      _controller.add(data);
    }));
    nativeStream.on('end', allowInterop(() {
      _controller.close();
    }));

    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

/// [StreamSink] wrapper around Node's `Writable` stream.
class WritableStream<S> implements StreamSink<S> {
  /// Native JavaScript Writable wrapped by this stream.
  ///
  /// It is not recommended to interact with this object directly.
  final js.Writable nativeStream;
  final Function _convert;

  Completer _drainCompleter;

  /// Creates new [WritableStream] which wraps [nativeStream].
  ///
  /// The [convert] hook is called for each element of this stream sink before
  /// it's added to the [nativeStream]. This allows implementations to convert
  /// Dart objects in to values accepted by JavaScript streams, if needed.
  WritableStream(this.nativeStream, {dynamic convert(S data)})
      : _convert = convert {
    nativeStream.on('error', allowInterop(_errorHandler));
  }

  void _errorHandler(error) {
    if (_drainCompleter != null && !_drainCompleter.isCompleted) {
      _drainCompleter.completeError(error); // TODO: dartify error
      return;
    }
    if (_closeCompleter != null && !_closeCompleter.isCompleted) {
      _closeCompleter.completeError(error);
    }
  }

  /// Writes [data] to nativeStream.
  void _write(S data) {
    var completer = new Completer();
    void _flush([error]) {
      if (!completer.isCompleted) completer.complete();
    }

    var chunk = (_convert == null) ? data : _convert(data);
    var isFlushed = nativeStream.write(chunk, allowInterop(_flush));
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
    return new Future.value();
  }

  @override
  void add(S data) {
    _write(data);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    nativeStream.destroy(error); // TODO: jsify error
  }

  @override
  Future addStream(Stream<S> stream) {
    throw new UnimplementedError();
  }

  @override
  Future close() {
    if (_closeCompleter != null) return _closeCompleter.future;
    _closeCompleter = new Completer();
    void end() {
      if (!_closeCompleter.isCompleted) _closeCompleter.complete();
    }

    nativeStream.end(allowInterop(end));
    return _closeCompleter.future;
  }

  Completer _closeCompleter;

  @override
  Future get done => close();
}

/// Writable stream of bytes, also accepts `String` values which are encoded
/// with specified [Encoding].
class NodeIOSink extends WritableStream<List<int>> implements IOSink {
  NodeIOSink(js.Writable nativeStream)
      : super(nativeStream, convert: (data) => Buffer.from(data));

  @override
  Encoding get encoding => Encoding.getByName('utf-8');

  @override
  set encoding(Encoding value) {
    throw new UnimplementedError();
  }

  @override
  Future flush() => drain;

  @override
  void write(Object obj) {
    _write(encoding.encode(obj.toString()));
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    var data = objects.map((obj) => obj.toString()).join(separator);
    _write(encoding.encode(data));
  }

  @override
  void writeCharCode(int charCode) {
    _write(encoding.encode(new String.fromCharCode(charCode)));
  }

  @override
  void writeln([Object obj = ""]) {
    _write(encoding.encode("$obj\n"));
  }
}
