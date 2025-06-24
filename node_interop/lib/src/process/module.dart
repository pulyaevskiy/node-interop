// Copyright (c) 2025, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:async/async.dart';
import 'package:js_core/js_core.dart';

import '../buffer/buffer.dart';
import '../events/event_emitter.dart';
import '../stream/readable.dart';
import '../stream/writable.dart';
import 'ipc_channel.dart';

@anonymous
extension type ProcessModule._(EventEmitter _) implements EventEmitter {
  /// A Dart broadcast stream wrapping [the `'beforeExit'` event].
  ///
  /// [the `'beforeExit'` event]: https://nodejs.org/docs/latest/api/process.html#event-beforeexit
  Stream<int> get onBeforeExit => eventAsStream<JSNumber>('beforeExit'.toJS)
      .map((exitCode) => exitCode.toDartInt);

  /// A Dart broadcast stream wrapping [the `'disconnect'` event].
  ///
  /// [the `'disconnect'` event]: https://nodejs.org/docs/latest/api/process.html#event-disconnect
  CancelableOperation<void> get onDisconnect =>
      onceAsCancelableOperation<Null>('disconnect'.toJS).then((_) {});

  /// A Dart broadcast stream wrapping [the `'exit'` event].
  ///
  /// [the `'exit'` event]: https://nodejs.org/docs/latest/api/process.html#event-exit
  CancelableOperation<int> get onExit =>
      onceAsCancelableOperation<JSNumber>('exit'.toJS)
          .then((exitCode) => exitCode[0].toDartInt);

  /// A Dart broadcast stream wrapping [the `'message'` event].
  ///
  /// [the `'message'` event]: https://nodejs.org/docs/latest/api/process.html#event-message
  Stream<(JSAny? message, JSObject? sendHandle)> get onMessage =>
      eventAsStreamPair('message'.toJS);

  /// A Dart broadcast stream wrapping [the `'rejectionHandled'` event].
  ///
  /// [the `'rejectionHandled'` event]: https://nodejs.org/docs/latest/api/process.html#event-rejectionhandled
  Stream<JSPromise<JSAny?>> get onRejectionHandled =>
      eventAsStream('rejectionHandled'.toJS);

  /// A Dart broadcast stream wrapping [the `'workerMessage'` event].
  ///
  /// [the `'workerMessage'` event]: https://nodejs.org/docs/latest/api/process.html#event-workermessage
  Stream<(JSAny? value, int source)> get onWorkerMessage =>
      eventAsStreamPair<JSAny?, JSNumber>('workerMessage'.toJS)
          .map((pair) => (pair.$1, pair.$2.toDartInt));

  /// A Dart broadcast stream wrapping [the `'uncaughtException'` event].
  ///
  /// [the `'uncaughtException'` event]: https://nodejs.org/docs/latest/api/process.html#event-uncaughtexception
  Stream<(JSError error, UncaughtExceptionType origin)>
      get onUncaughtException =>
          eventAsStreamPair<JSError, JSString>('uncaughtException'.toJS)
              .map((pair) => (
                    pair.$1,
                    pair.$2.toDart == 'unhandledRejection'
                        ? UncaughtExceptionType.unhandledRejection
                        : UncaughtExceptionType.uncaughtException
                  ));

  /// A Dart broadcast stream wrapping [the `'uncaughtExceptionMonitor'` event].
  ///
  /// [the `'uncaughtExceptionMonitor'` event]: https://nodejs.org/docs/latest/api/process.html#event-uncaughtexceptionmonitor
  Stream<(JSError error, UncaughtExceptionType origin)>
      get onUncaughtExceptionMonitor =>
          eventAsStreamPair<JSError, JSString>('uncaughtExceptionMonitor'.toJS)
              .map((pair) => (
                    pair.$1,
                    pair.$2.toDart == 'unhandledRejection'
                        ? UncaughtExceptionType.unhandledRejection
                        : UncaughtExceptionType.uncaughtException
                  ));

  /// A Dart broadcast stream wrapping [the `'unhandledRejection'` event].
  ///
  /// [the `'unhandledRejection'` event]: https://nodejs.org/docs/latest/api/process.html#event-unhandledrejection
  Stream<(JSAny? error, JSPromise promise)> get onUnhandledRejection =>
      eventAsStreamPair('unhandledRejection'.toJS);

  /// A Dart broadcast stream wrapping [the `'warning'` event].
  ///
  /// [the `'warning'` event]: https://nodejs.org/docs/latest/api/process.html#event-warning
  Stream<ProcessWarning> get onWarning => eventAsStream('warning'.toJS);

  // TODO: Add a wrapper for the `'worker'` event once we have typings for the
  // `Worker` type.

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processallowednodeenvironmentflags
  external JSSet<JSString> get allowedNodeEnvironmentFlags;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processarch
  external String get arch;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processargv
  @JS('argv')
  external JSArray<JSString> get arguments;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processavailablememory
  int get availableMemory => _availableMemory();

  @JS('availableMemory')
  external int _availableMemory();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processargv
  @JS('argv0')
  external String get firstArgument;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processchannel
  external IpcChannel? get channel;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processconfig
  external JSRecord get config;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processconnected
  external bool get connected;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processconstrainedmemory
  int get constrainedMemory => _constrainedMemory();

  @JS('constrainedMemory')
  external int _constrainedMemory();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processcwd
  String get currentWorkingDir => _currentWorkingDir();

  @JS('cwd')
  external String _currentWorkingDir();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processdebugport
  external int get debugPort;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processenv
  external JSRecord<JSString> get env;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processexecargv
  @JS('execArgv')
  external JSArray<JSString> get executableArguments;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processexecpath
  @JS('execPath')
  external String get executablePath;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processfeaturescached_builtins
  external JSRecord<JSBoolean> get features;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processexitcode_1
  external int exitCode;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgetegid
  int get effectiveGroupID => _getEffectiveGroupID();
  set effectiveGroupID(int value) => _setEffectiveGroupID(value);

  @JS('getegid')
  external int _getEffectiveGroupID();

  @JS('setegid')
  external void _setEffectiveGroupID(int value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgeteuid
  int get effectiveUserID => _getEffectiveUserID();
  set effectiveUserID(int value) => _setEffectiveUserID(value);

  @JS('geteuid')
  external int _getEffectiveUserID();

  @JS('seteuid')
  external void _setEffectiveUserID(int value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgetgid
  int get groupID => _getGroupID();
  set groupID(int value) => _setGroupID(value);

  @JS('getgid')
  external int _getGroupID();

  @JS('setgid')
  external void _setGroupID(int value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgetgroups
  JSArray<JSNumber> get groups => _getGroups();
  set groups(JSArray<JSNumber> value) => _setGroups(value);

  @JS('getgroups')
  external JSArray<JSNumber> _getGroups();

  @JS('setgroups')
  external void _setGroups(JSArray<JSNumber> value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgetuid
  int get userID => _getUserID();
  set userID(int value) => _setUserID(value);

  @JS('getuid')
  external int _getUserID();

  @JS('setuid')
  external void _setUserID(int value);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processhasuncaughtexceptioncapturecallback
  bool get hasUncaughtExceptionCaptureCallback =>
      _hasUncaughtExceptionCaptureCallback();

  @JS('hasUncaughtExceptionCaptureCallback')
  external bool _hasUncaughtExceptionCaptureCallback();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processhrtimebigint
  JSBigInt get highResolutionTime => _highResolutionTime.bigint();

  @JS('hrtime')
  external _HighResolutionTimeSubmodule get _highResolutionTime;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processmemoryusage
  ProcessMemoryUsage get memoryUsage => _memoryUsage();

  @JS('memoryUsage')
  external ProcessMemoryUsage _memoryUsage();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processmemoryusage
  int get residentSetMemoryUsage => _memoryUsageSubmodule.residentSetSize();

  @JS('memoryUsage')
  external _MemoryUsageSubmodule get _memoryUsageSubmodule;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processnodeprecation
  external bool get noDeprecation;

  // TODO: Add types for the `permission` getter once we type the permissions module.

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processpid
  @JS('pid')
  external int get processID;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processplatform
  external String get platform;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processppidc
  @JS('ppid')
  external int get parentProcessID;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processrelease
  external ProcessReleaseInfo get release;

  // TODO: Add types for the `report` getter once we type the report module.

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processrelease
  ProcessResourceUsage get resourceUsage => _resourceUsage();

  @JS('resourceUsage')
  external ProcessResourceUsage _resourceUsage();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processstderr
  ///
  /// [JSString]s, [JSTypedArray]s, and [JSDataView]s can all be written to this
  /// writable.
  @JS('stderr')
  external NodeWritable get standardError;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processstderrfd
  int? get standardErrorFileDescriptor =>
      standardError.getProperty<JSNumber?>('fd'.toJS)?.toDartInt;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processstdin
  @JS('stdin')
  external NodeReadable<Buffer> get standardInput;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processstdinfd
  int? get standardInputFileDescriptor =>
      standardInput.getProperty<JSNumber?>('fd'.toJS)?.toDartInt;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processstdout
  ///
  /// [JSString]s, [JSTypedArray]s, and [JSDataView]s can all be written to this
  /// writable.
  @JS('stdout')
  external NodeWritable get standardOutput;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processstdoutfd
  int? get standardOutputFileDescriptor =>
      standardOutput.getProperty<JSNumber?>('fd'.toJS)?.toDartInt;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processthrowdeprecation
  external bool throwDeprecation;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processtitle
  external String title;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processtracedeprecation
  external bool get traceDeprecation;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processversion
  external String get version;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processversions
  external JSRecord<JSString> get versions;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processabort
  external void abort();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processchdirdirectory
  external void changeDir(String directory);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processcpuusagepreviousvalue
  external CpuUsageResult cpuUsage([CpuUsageResult? previousValue]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processdisconnect
  external void disconnect();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processdlopenmodule-filename-flags
  @JS('dlopen')
  external void dynamicLoadOpen(JSObject module, String filename, [int? flags]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processemitwarningwarning-options
  void emitWarning(JSAny warning,
      {String? type, String? code, JSFunction? constructor, String? detail}) {
    var options = _WarningOptions();
    if (type != null) options.type = type;
    if (code != null) options.code = code;
    if (constructor != null) options.constructor = constructor;
    if (detail != null) options.detail = detail;
    _emitWarning(warning, options);
  }

  @JS('emitWarning')
  external void _emitWarning(JSAny warning, [_WarningOptions? options]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processexitcode
  external Never exit([int? code]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgetactiveresourcesinfo
  external JSArray<JSString> getActiveResourcesInfo();

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processgetbuiltinmoduleid
  external T? getBuiltInModule<T extends JSObject>(String id);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processinitgroupsuser-extragroup
  ///
  /// The [user] and [extraGroup] arguments can be [JSString]s or [JSNumber]s.
  external void initGroups(JSAny user, JSAny extraGroup);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processsendmessage-sendhandle-options-callback
  ///
  /// This is returned as a nullable function because it's only defined if
  /// there's an IPC channel open in the current process.
  bool Function(JSAny? message, {JSFunction? callback})? get send {
    if (_send == null) return null;
    return (message, {callback}) =>
        callback == null ? _send2(message, callback) : _send2(message);
  }

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processsendmessage-sendhandle-options-callback
  ///
  /// This is returned as a nullable function because it's only defined if
  /// there's an IPC channel open in the current process.
  bool Function(JSAny? message, JSObject sendHandle,
      {bool? keepOpen, JSFunction? callback})? get sendWithHandle {
    if (_send == null) return null;
    return (message, sendHandle, {keepOpen, callback}) =>
        switch ((keepOpen, callback)) {
          (_?, _?) => _send4(
              message, sendHandle, _SendOptions(keepOpen: keepOpen), callback),
          (_?, null) =>
            _send4(message, sendHandle, _SendOptions(keepOpen: keepOpen)),
          (null, _?) => _send3(message, sendHandle, callback),
          _ => _send3(message, sendHandle)
        };
  }

  @JS('send')
  external bool _send4(JSAny? message, JSObject sendHandle,
      [_SendOptions? options, JSFunction? callback]);

  @JS('send')
  external bool _send3(JSAny? message, JSObject sendHandle,
      [JSFunction? callback]);

  @JS('send')
  external bool _send2(JSAny? message, [JSFunction? callback]);

  // `send()` is undefined outside of a
  @JS('send')
  external JSFunction? _send;

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processkillpid-signal
  ///
  /// The [signal] argument can be a [JSString] or a [JSNumber].
  external void kill(int pid, [JSAny? signal]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processsetuncaughtexceptioncapturecallbackfn
  void setUncaughtExceptionCaptureCallback(
          void Function(JSAny? exception)? callback) =>
      _setUncaughtExceptionCaptureCallback(callback?.toJS);

  @JS('setUncaughtExceptionCaptureCallback')
  external void _setUncaughtExceptionCaptureCallback(JSFunction? function);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processthreadcpuusagepreviousvalue
  @JS('threadCpuUsage')
  external ThreadCpuUsageInfo threadCpuUsage(
      [ThreadCpuUsageInfo? previousValue]);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processumaskmask
  ///
  /// The [mask] argument may be a [JSString] or a [JSNumber].
  @JS('umask')
  external void setFileModeCreationMask(JSAny mask);

  /// See [the Node.js documentation].
  ///
  /// [the Node.js documentation]: https://nodejs.org/docs/latest/api/process.html#processuptime
  external int uptime();
}

/// Possible exception types emitted by [ProcessModule.onUncaughtException] and [ProcessModule.onUncaughtExceptionMonitor].
enum UncaughtExceptionType { uncaughtException, unhandledRejection }

/// The type of event emitted by [ProcessModule.onWarning].
@anonymous
extension type ProcessWarning._(JSObject _) implements JSObject {
  external String get name;
  external String get message;
  external String get stack;
}

/// The type returned by [ProcessModule.cpuUsage].
@anonymous
extension type CpuUsageResult._(JSObject _) implements JSObject {
  external int get user;
  external int get system;
}

/// The options passed to [ProcessModule.emitWarning].
@anonymous
extension type _WarningOptions._(JSObject _) implements JSObject {
  external String? type;
  external String? code;
  @JS('ctor')
  external JSFunction? constructor;
  external String? detail;

  external _WarningOptions();
}

/// The `process.hrtime` object.
@anonymous
extension type _HighResolutionTimeSubmodule._(JSObject _) implements JSObject {
  external JSBigInt bigint();
}

/// The value returned by [ProcessModule.memoryUsage].
@anonymous
extension type ProcessMemoryUsage._(JSObject _) implements JSObject {
  @JS('rss')
  external int get residentSetSize;
  external int get heapTotal;
  external int get heapUsed;
  external int get external;
  external int get arrayBuffers;
}

/// The `process.memoryUsage` object.
@anonymous
extension type _MemoryUsageSubmodule._(JSObject _) implements JSObject {
  @JS('rss')
  external int residentSetSize();
}

/// The `process.release` object.
@anonymous
extension type ProcessReleaseInfo._(JSObject _) implements JSObject {
  external String get node;
  external String get sourceUrl;
  external String get headersUrl;
  external String? get libUrl;
  external String? get lts;
}

/// The `process.resourceUsage` object.
@anonymous
extension type ProcessResourceUsage._(JSObject _) implements JSObject {
  @JS('userCPUTime')
  external int get userCpuTime;
  @JS('systemCPUTime')
  external int get systemCpuTime;
  @JS('maxRSS')
  external int get maxResidentSetSize;
  external int get sharedMemorySize;
  external int get unsharedDataSize;
  external int get unsharedStackSize;
  external int get minorPageFault;
  external int get majorPageFault;
  external int get swappedOut;
  external int get fsRead;
  external int get fsWrite;
  external int get ipcSent;
  external int get ipcReceived;
  external int get signalsCount;
  external int get voluntaryContextSwitches;
  external int get involuntaryContextSwitches;
}

/// The options passed to [Process.send].
@anonymous
extension type _SendOptions._(JSObject _) implements JSObject {
  external bool keepOpen;

  external _SendOptions({bool? keepOpen});
}

/// The value returned by [process.threadCpuUsage].
@anonymous
extension type ThreadCpuUsageInfo._(JSObject _) implements JSObject {
  external int get user;
  external int get system;
}
