// Copyright (c) 2020, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "worker_threads" module bindings.
///
/// Use top-level [worker] object to access this module functionality.
@JS()
library node_interop.worker;

import 'dart:js_util';

import 'package:js/js.dart';

import 'events.dart';
import 'js.dart';
import 'node.dart';
import 'stream.dart';

final worker = require('worker_threads') as WorkerThreadsModule;

@JS()
@anonymous
abstract class WorkerThreadsModule {
  external bool get isMainThread;
  external void markAsUntransferable(Object object);
  external WorkerMessagePort get parentPort;
  external ReceivedMessage receiveMessageOnPort(WorkerMessagePort port);
  external ResourceLimits get resourceLimits;
  external Object get SHARE_ENV;
  external int get threadId;
  external Object get workerData;

  /// The constructor function for [MessageChannel].
  external Function get MessageChannel;

  /// The constructor function for [WorkerMessagePort].
  external Function get MessagePort;

  /// The constructor function for [Worker].
  external Function get Worker;
}

/// Creates a [MessageChannel] using `new MessageChanel()`.
MessageChannel createMessageChannel() =>
    callConstructor(worker.MessageChannel, []);

/// Creates a [Worker] using `new Worker().
Worker createWorker(String filename, [WorkerOptions options]) =>
    callConstructor(worker.Worker, [filename, options]);

abstract class ReceivedMessage {
  Object get message;
}

@JS()
@anonymous
abstract class ResourceLimits {
  external factory ResourceLimits(
      {int maxYoungGenerationSizeMb,
      int maxOldGenerationSizeMb,
      int codeRangeSizeMb,
      int stackSizeMb});

  int get maxYoungGenerationSizeMb;
  int get maxOldGenerationSizeMb;
  int get codeRangeSizeMb;
  int get stackSizeMb;
}

@JS()
@anonymous
abstract class MessageChannel {
  external WorkerMessagePort get port1;
  external WorkerMessagePort get port2;
}

/// An interface for the common message-passing methods between
/// [WorkerMessagePort] and [Worker].
abstract class MessagePasser implements EventEmitter {
  void postMessage(Object value, [List<Object> transferList]);
  void ref();
  void unref();
}

// This can't be called `MessagePort` or we run into problems with
// dart-lang/sdk#26818.
@JS()
@anonymous
abstract class WorkerMessagePort implements MessagePasser {
  external void close();
  @override
  external void postMessage(Object value, [List<Object> transferList]);
  @override
  external void ref();
  external void start();
  @override
  external void unref();
}

@JS()
@anonymous
abstract class Worker implements MessagePasser {
  external Promise getHeapSnapshot();
  @override
  external void postMessage(Object value, [List<Object> transferList]);
  @override
  external void ref();
  external ResourceLimits get resourceLimits;
  external Readable get stderr;
  external Writable get stdin;
  external Readable get stdout;
  external Promise terminate();
  external int get threadId;
  @override
  external void unref();
}

@JS()
@anonymous
abstract class WorkerOptions {
  external factory WorkerOptions(
      {List<Object> argv,
      Object env,
      bool eval,
      List<String> execArgv,
      bool stdin,
      bool stdout,
      bool stderr,
      Object workerData,
      bool trackUnmanagedFds,
      List<Object> transferList,
      ResourceLimits resourceLimits});

  List<Object> get argv;
  Object get env;
  bool get eval;
  List<String> get execArgv;
  bool get stdin;
  bool get stdout;
  bool get stderr;
  Object get workerData;
  bool get trackUnmanagedFds;
  List<Object> get transferList;
  ResourceLimits get resourceLimits;
}
