# Implementation status

This document shows which `dart:io` APIs have been implemented so far in `node_io`.

## Classes

-[x] BytesBuilder
-[ ] CompressionOptions
-[ ] ConnectionTask
-[x] ContentType
-[x] Cookie
-[x] Datagram
-[ ] DetachedSocket
-[x] Directory
-[x] File
-[ ] FileLock (not supported by Node.js)
-[x] FileMode
-[x] FileStat
-[ ] FileSystemCreateEvent
-[ ] FileSystemDeleteEvent
-[x] FileSystemEntity
-[x] FileSystemEntityType
-[ ] FileSystemEvent
-[ ] FileSystemModifyEvent
-[ ] FileSystemMoveEvent
-[ ] GZipCodec
-[x] HeaderValue
-[ ] HttpClient
-[ ] HttpClientBasicCredentials
-[ ] HttpClientCredentials
-[ ] HttpClientDigestCredentials
-[ ] HttpClientRequest
-[ ] HttpClientResponse
-[x] HttpConnectionInfo
-[ ] HttpConnectionsInfo
-[x] HttpDate
-[x] HttpHeaders
-[ ] HttpOverrides
-[x] HttpRequest
-[x] HttpResponse
-[x] HttpServer
-[ ] HttpSession
-[x] HttpStatus
-[x] InternetAddress
-[x] InternetAddressType
-[ ] IOOverrides
-[x] IOSink
-[x] Link
-[x] NetworkInterface
-[x] OSError
-[x] Platform
-[ ] Process
-[ ] ProcessInfo
-[ ] ProcessResult
-[ ] ProcessSignal
-[ ] ProcessStartMode
-[x] RandomAccessFile
-[ ] RawDatagramSocket
-[ ] RawSecureServerSocket
-[ ] RawSecureSocket
-[ ] RawServerSocket
-[ ] RawSocket
-[ ] RawSocketEvent
-[ ] RawSocketOption
-[ ] RawSynchronousSocket
-[ ] RawZLibFilter
-[ ] RedirectInfo
-[ ] SecureServerSocket
-[ ] SecureSocket
-[ ] SecurityContext
-[ ] ServerSocket
-[ ] Socket
-[ ] SocketDirection
-[ ] SocketOption
-[ ] Stdin
-[ ] StdioType
-[ ] Stdout
-[ ] SystemEncoding
-[ ] WebSocket
-[ ] WebSocketStatus
-[ ] WebSocketTransformer
-[ ] X509Certificate
-[ ] ZLibCodec
-[ ] ZLibDecoder
-[ ] ZLibEncoder
-[ ] ZLibOption

### Properties

-[x] exitCode
-[x] pid
-[ ] stderr
-[ ] stdin
-[ ] stdout

### Functions

-[x] exit
-[ ] sleep
-[ ] stdioType

### Typedefs

-[ ] BadCertificateCallback

### Exceptions

-[ ] CertificateException
-[ ] FileSystemException
-[ ] HandshakeException
-[x] HttpException
-[ ] IOException
-[ ] ProcessException
-[ ] RedirectException
-[ ] SignalException
-[ ] SocketException
-[ ] StdinException
-[ ] StdoutException
-[ ] TlsException
-[ ] WebSocketException
