library jaguar.src.serve;

import 'dart:async';
import 'dart:io';
import 'dart:collection';

import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';

import 'package:jaguar/src/serve/error_writer/import.dart';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

export 'package:jaguar/src/serve/error_writer/import.dart';
import 'package:path/path.dart' as p;

part 'debug.dart';
part 'handler.dart';
part 'settings.dart';

/// Base class for Request handlers
abstract class RequestHandler {
  FutureOr<Response> handleRequest(Context ctx, {String prefix});
}

/// An exception that can make an error [Response]
abstract class ResponseError {
  /// Creates [Response] from error
  Response response(Context ctx);
}

/// The Jaguar server
///
///
class Jaguar extends Object with Muxable, _Handler {
  /// Address on which the API is serviced
  final String address;

  /// Port on which the API is serviced
  final int port;

  /// Security context for HTTPS
  final SecurityContext securityContext;

  /// Should the port be service-able from multiple isolates?
  ///
  /// Defaults to false.
  final bool multiThread;

  /// Should the response be auto-compressed?
  ///
  /// Defaults to false.
  final bool autoCompress;

  /// Base path of the served api.
  ///
  /// Defaults to '' (Aka. No base path).
  final String basePath;

  /// Used to write error pages in case of HTTP errors.
  ///
  /// Defaults to [DefaultErrorWriter].
  final ErrorWriter errorWriter;

  /// Session manager to parse and update session data for requests.
  ///
  /// Defaults to [CookieSessionManager].
  final SessionManager sessionManager;

  /// Logger used to log concise useful information about the request. This is
  /// also available in [Context] so that interceptors and route handlers can also
  /// log.
  final Logger log = new Logger('J');

  /// Stream of information about requests used for debugging purposes.
  final DebugStream debugStream;

  /// Internal http server
  HttpServer _server;

  /// Returns protocol string
  String get protocolStr => securityContext == null ? 'http' : 'https';

  /// Base path
  String get resourceName => "$protocolStr://$address:$port/";

  /// Constructs an instance of [Jaguar] with given configuration.
  ///
  /// [address]:[port] is the address and port at which the HTTP requests are
  /// listened.
  /// [multiThread] determines if the port can be serviced from multiple isolates.
  /// [securityContext] is used to configure HTTPS support.
  /// [autoCompress] determines if the response should be automatically compressed.
  /// [basePath] is the path prefix added to all constituting routes of this
  /// server.
  /// [errorWriter] is used to write custom error page [Response] in cases of HTTP
  /// errors.
  /// [debugStream] is used to expose information about requests. Very helpful for
  /// debugging purposes.
  /// [sessionManager] provides ability to use custom session managers.
  Jaguar(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.securityContext: null,
      this.autoCompress: false,
      this.basePath: '',
      ErrorWriter errorWriter,
      this.debugStream,
      SessionManager sessionManager})
      : errorWriter = errorWriter ?? new DefaultErrorWriter(),
        sessionManager = sessionManager ?? new CookieSessionManager();

  /// Starts serving the HTTP requests.
  Future<Null> serve() async {
    if (_server != null) throw new Exception('Already serving!');
    log.info("Running on $resourceName");
    _buildHandlers();
    if (securityContext != null) {
      _server = await HttpServer.bindSecure(address, port, securityContext);
    } else {
      _server = await HttpServer.bind(address, port, shared: multiThread);
    }
    _server.autoCompress = autoCompress;
    _server.listen(_handleRequest);
  }

  /// Closes the server
  Future<Null> close() async {
    await _server.close(force: true);
    _server = null;
    _builtHandlers.clear();
  }

  /// Global interceptors
  final _interceptorCreators = <InterceptorCreator>[];

  UnmodifiableListView<InterceptorCreator> get interceptorCreators =>
      new UnmodifiableListView<InterceptorCreator>(_interceptorCreators);

  /// Wraps interceptor creator around all routes
  void wrap(InterceptorCreator creator) => _interceptorCreators.add(creator);

  /// [RequestHandler]s added to this server
  final _unbuiltRoutes = <dynamic>[];

  /// Built [RequestHandler]s
  final _builtHandlers = <RequestHandler>[];

  /// Adds the given [api] to list of API that will be served
  void addApi(RequestHandler api) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _unbuiltRoutes.add(api);
  }

  /// Serves requests for static files at [path] from [directory]
  ///
  /// [stripPrefix] parameter determines if the matched part of the path shall be
  /// discarded while locating the target file.
  ///
  /// When [stripPrefix] is true, the behaviour is similar to 'alias' in Nginx.
  ///
  /// With [path] '/static/*', the target file will be located inside [directory]
  /// in the following way:
  ///
  /// /static/html/index.html -> html/index.html
  ///
  /// When [stripPrefix] is false, the behavior is similar to 'root' in Nginx.
  ///
  /// With [path] '/static/*', the target file will be located inside [directory]
  /// in the following way:
  ///
  /// /static/html/index.html -> static/html/index.html
  ///
  /// Example:
  ///    final server = new Jaguar();
  ///    server.staticFiles('/static/*', 'static');
  ///    await server.serve();
  void staticFiles(String path, directory,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      bool stripPrefix: true}) {
    if (directory is String) {
      directory = new Directory(directory);
    }

    final Directory dir = directory;
    if (!dir.existsSync())
      throw new Exception('Directory ${dir.path} does not exist!');

    List<String> parts = splitPathToSegments(path);

    int len = parts.length;
    if (parts.last == '*') len--;

    get(path, (Context ctx) async {
      final List<String> paths = stripPrefix
          ? ctx.uri.pathSegments.sublist(len)
          : ctx.uri.pathSegments;
      final String path = p.join(dir.path, p.joinAll(paths));
      final File file = new File(path);
      if (!await file.exists()) return null;
      return new Response<Stream<List<int>>>(await file.openRead(),
          mimeType: MimeType.ofFile(file));
    },
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: kDefaultCharset,
        headers: headers);
  }

  /// Serves requests at [path] with content of [file]
  ///
  /// Example:
  ///    final server = new Jaguar();
  ///    server.staticFile('/hello', p.join('static', 'hello.txt'));
  ///    await server.serve();
  void staticFile(String path, file,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    if (file is String) {
      file = new File(file);
    }

    final File f = file;
    get(path, (_) => f.openRead(),
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType ?? MimeType.ofFile(f) ?? kDefaultMimeType,
        charset: kDefaultCharset,
        headers: headers);
  }

  /// Adds the [route] to be served
  RouteBuilder addRoute(RouteBuilder route) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }

    _unbuiltRoutes.add(route);
    return route;
  }

  /// Create a new route group
  GroupBuilder group([String path = '']) {
    return new GroupBuilder(this, path: path);
  }

  /// Builds handlers to be served
  void _buildHandlers() {
    _builtHandlers.clear();
    for (dynamic handler in _unbuiltRoutes) {
      if (handler is RequestHandler) {
        _builtHandlers.add(handler);
      } else if (handler is RouteBuilder) {
        final Route jRoute = new Route(
            path: handler.path,
            methods: handler.methods,
            statusCode: handler.statusCode,
            mimeType: handler.mimeType,
            charset: handler.charset,
            headers: handler.headers,
            pathRegEx: handler.pathRegEx);

        if (handler.interceptors.length == 0 &&
            handler.exceptionHandlers.length == 0) {
          _builtHandlers.add(new RouteChainSimple(jRoute, '', handler.handler));
        } else {
          _builtHandlers.add(new RouteChain(jRoute, '', handler.handler,
              handler.interceptors, handler.exceptionHandlers));
        }
      }
    }
  }
}
