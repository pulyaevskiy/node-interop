// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Node.js "os" module bindings.
///
/// Use library-level [os] object to access functionality of this module.
@JS()
library node_interop.os;

import 'package:js/js.dart';

import 'node.dart';

OS get os => _os ??= require('os');
OS _os;

@JS()
@anonymous
abstract class OS {
  external String get EOL;
  external String arch();
  external OSConstants get constants;
  external List<CPU> cpus();
  external String endianness();
  external int freemem();
  external String homedir();
  external String hostname();
  external List<int> loadavg();
  external dynamic networkInterfaces();
  external String platform();
  external String release();
  external String tmpdir();
  external int totalmem();
  external String type();
  external int uptime();
  external dynamic userInfo([options]);
}

@JS()
@anonymous
abstract class CPU {
  external String get model;
  external num get speed;
  external CPUTimes get times;
}

@JS()
@anonymous
abstract class CPUTimes {
  external num get user;
  external num get nice;
  external num get sys;
  external num get idle;
  external num get irq;
}

@JS()
@anonymous
abstract class OSConstants {
  external OSSignalConstants get signals;
  external OSErrorConstants get errno;
  external OSDLOpenConstants get dlopen;
}

@JS()
@anonymous
abstract class OSSignalConstants {
  external int get SIGHUP;
  external int get SIGINT;
  external int get SIGQUIT;
  external int get SIGILL;
  external int get SIGTRAP;
  external int get SIGABRT;
  external int get SIGIOT;
  external int get SIGBUS;
  external int get SIGFPE;
  external int get SIGKILL;
  external int get SIGUSR1;
  external int get SIGUSR2;
  external int get SIGSEGV;
  external int get SIGPIPE;
  external int get SIGALRM;
  external int get SIGTERM;
  external int get SIGCHLD;
  external int get SIGSTKFLT;
  external int get SIGCONT;
  external int get SIGSTOP;
  external int get SIGTSTP;
  external int get SIGBREAK;
  external int get SIGTTIN;
  external int get SIGTTOU;
  external int get SIGURG;
  external int get SIGXCPU;
  external int get SIGXFSZ;
  external int get SIGVTALRM;
  external int get SIGPROF;
  external int get SIGWINCH;
  external int get SIGIO;
  external int get SIGPOLL;
  external int get SIGLOST;
  external int get SIGPWR;
  external int get SIGINFO;
  external int get SIGSYS;
  external int get SIGUNUSED;
}

@JS()
@anonymous
abstract class OSErrorConstants {
  external int get E2BIG;
  external int get EACCES;
  external int get EADDRINUSE;
  external int get EADDRNOTAVAIL;
  external int get EAFNOSUPPORT;
  external int get EAGAIN;
  external int get EALREADY;
  external int get EBADF;
  external int get EBADMSG;
  external int get EBUSY;
  external int get ECANCELED;
  external int get ECHILD;
  external int get ECONNABORTED;
  external int get ECONNREFUSED;
  external int get ECONNRESET;
  external int get EDEADLK;
  external int get EDESTADDRREQ;
  external int get EDOM;
  external int get EDQUOT;
  external int get EEXIST;
  external int get EFAULT;
  external int get EFBIG;
  external int get EHOSTUNREACH;
  external int get EIDRM;
  external int get EILSEQ;
  external int get EINPROGRESS;
  external int get EINTR;
  external int get EINVAL;
  external int get EIO;
  external int get EISCONN;
  external int get EISDIR;
  external int get ELOOP;
  external int get EMFILE;
  external int get EMLINK;
  external int get EMSGSIZE;
  external int get EMULTIHOP;
  external int get ENAMETOOLONG;
  external int get ENETDOWN;
  external int get ENETRESET;
  external int get ENETUNREACH;
  external int get ENFILE;
  external int get ENOBUFS;
  external int get ENODATA;
  external int get ENODEV;
  external int get ENOENT;
  external int get ENOEXEC;
  external int get ENOLCK;
  external int get ENOLINK;
  external int get ENOMEM;
  external int get ENOMSG;
  external int get ENOPROTOOPT;
  external int get ENOSPC;
  external int get ENOSR;
  external int get ENOSTR;
  external int get ENOSYS;
  external int get ENOTCONN;
  external int get ENOTDIR;
  external int get ENOTEMPTY;
  external int get ENOTSOCK;
  external int get ENOTSUP;
  external int get ENOTTY;
  external int get ENXIO;
  external int get EOPNOTSUPP;
  external int get EOVERFLOW;
  external int get EPERM;
  external int get EPIPE;
  external int get EPROTO;
  external int get EPROTONOSUPPORT;
  external int get EPROTOTYPE;
  external int get ERANGE;
  external int get EROFS;
  external int get ESPIPE;
  external int get ESRCH;
  external int get ESTALE;
  external int get ETIME;
  external int get ETIMEDOUT;
  external int get ETXTBSY;
  external int get EWOULDBLOCK;
  external int get EXDEV;
  // Windows specific error constants
  external int get WSAEINTR;
  external int get WSAEBADF;
  external int get WSAEACCES;
  external int get WSAEFAULT;
  external int get WSAEINVAL;
  external int get WSAEMFILE;
  external int get WSAEWOULDBLOCK;
  external int get WSAEINPROGRESS;
  external int get WSAEALREADY;
  external int get WSAENOTSOCK;
  external int get WSAEDESTADDRREQ;
  external int get WSAEMSGSIZE;
  external int get WSAEPROTOTYPE;
  external int get WSAENOPROTOOPT;
  external int get WSAEPROTONOSUPPORT;
  external int get WSAESOCKTNOSUPPORT;
  external int get WSAEOPNOTSUPP;
  external int get WSAEPFNOSUPPORT;
  external int get WSAEAFNOSUPPORT;
  external int get WSAEADDRINUSE;
  external int get WSAEADDRNOTAVAIL;
  external int get WSAENETDOWN;
  external int get WSAENETUNREACH;
  external int get WSAENETRESET;
  external int get WSAECONNABORTED;
  external int get WSAECONNRESET;
  external int get WSAENOBUFS;
  external int get WSAEISCONN;
  external int get WSAENOTCONN;
  external int get WSAESHUTDOWN;
  external int get WSAETOOMANYREFS;
  external int get WSAETIMEDOUT;
  external int get WSAECONNREFUSED;
  external int get WSAELOOP;
  external int get WSAENAMETOOLONG;
  external int get WSAEHOSTDOWN;
  external int get WSAEHOSTUNREACH;
  external int get WSAENOTEMPTY;
  external int get WSAEPROCLIM;
  external int get WSAEUSERS;
  external int get WSAEDQUOT;
  external int get WSAESTALE;
  external int get WSAEREMOTE;
  external int get WSASYSNOTREADY;
  external int get WSAVERNOTSUPPORTED;
  external int get WSANOTINITIALISED;
  external int get WSAEDISCON;
  external int get WSAENOMORE;
  external int get WSAECANCELLED;
  external int get WSAEINVALIDPROCTABLE;
  external int get WSAEINVALIDPROVIDER;
  external int get WSAEPROVIDERFAILEDINIT;
  external int get WSASYSCALLFAILURE;
  external int get WSASERVICE_NOT_FOUND;
  external int get WSATYPE_NOT_FOUND;
  external int get WSA_E_NO_MORE;
  external int get WSA_E_CANCELLED;
  external int get WSAEREFUSED;
}

@JS()
@anonymous
abstract class OSDLOpenConstants {
  external int get RTLD_LAZY;
  external int get RTLD_NOW;
  external int get RTLD_GLOBAL;
  external int get RTLD_LOCAL;
  external int get RTLD_DEEPBIND;
}
