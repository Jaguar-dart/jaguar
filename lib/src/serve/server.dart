library jaguar.src.serve;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';

import 'package:jaguar/src/serve/error_writer/import.dart';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

export 'package:jaguar/src/serve/error_writer/import.dart';
import 'package:path/path.dart' as p;

part 'settings.dart';

/// Base class for Request handlers
abstract class RequestHandler {
  FutureOr<Response> handleRequest(Context ctx, {String prefix});
}

/// The Jaguar server
class Jaguar extends Object with Muxable {
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

  /// Returns protocol string
  String get protocolStr => securityContext == null ? 'http' : 'https';

  /// Base path
  String get resourceName => "$protocolStr://$address:$port/";

  /// Internal http server
  HttpServer _server;

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
  /// [sessionManager] provides ability to use custom session managers.
  Jaguar(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.securityContext: null,
      this.autoCompress: false,
      this.basePath: '',
      ErrorWriter errorWriter,
      SessionManager sessionManager})
      : errorWriter = errorWriter ?? new DefaultErrorWriter(),
        sessionManager = sessionManager ?? new CookieSessionManager();

  /// Starts serving the HTTP requests.
  Future<Null> serve({bool logRequests: false}) async {
    if (_server != null) throw new Exception('Already serving!');
    log.info("Running on $resourceName");
    _handlers = _buildHandlers();
    if (securityContext != null) {
      _server = await HttpServer.bindSecure(address, port, securityContext);
    } else {
      _server = await HttpServer.bind(address, port, shared: multiThread);
    }
    _server.autoCompress = autoCompress;
    if (logRequests) {
      _server.listen((HttpRequest r) {
        log.info("Req => Method: ${r.method} Url: ${r.uri}");
        _handler(r);
      });
    } else {
      _server.listen(_handler);
    }
  }

  Future _handler(HttpRequest request) async {
    final ctx = new Context(new Request(request, log), sessionManager);

    Response response;
    try {
      // Try to find a matching route and invoke it.
      for (RequestHandler requestHandler in _handlers) {
        response = await requestHandler.handleRequest(ctx, prefix: basePath);
        if (response != null) break;
      }

      // If no response, write 404 error.
      if (response == null) {
        response = errorWriter.make404(ctx);
      }
    } catch (e, stack) {
      if (e is Response) {
        // If [Response] object was thrown, write it!
        response = e;
      } else {
        response = errorWriter.make500(ctx, e, stack);
      }
    }

    try {
      // Update session, if required.
      if (ctx.sessionNeedsUpdate) await sessionManager.write(ctx, response);
    } catch (_) {}

    // Write response
    try {
      await response.writeResponse(request.response);
    } catch (_) {}

    return request.response.close();
  }

  /// Closes the server
  Future<Null> close() async {
    await _server.close(force: true);
    _server = null;
    _handlers.clear();
  }

  /// Built [RequestHandler]s
  List<RequestHandler> _handlers = <RequestHandler>[];

  /// Adds the given [api] to list of API that will be served
  void addApi(RequestHandler api) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _unbuiltRoutes.add(api);
  }

  /// Adds the [route] to be served
  RouteBuilder addRoute(RouteBuilder route) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _unbuiltRoutes.add(route);
    return route;
  }

  /// [RequestHandler]s added to this server
  List _unbuiltRoutes = [];

  /// Create a new route group
  GroupBuilder group([String path = '']) => new GroupBuilder(this, path: path);

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

    this.get(path, (Context ctx) async {
      final List<String> paths = stripPrefix
          ? ctx.uri.pathSegments.sublist(len)
          : ctx.uri.pathSegments;
      String path = p.join(dir.path, p.joinAll(paths));
      File file = new File(path);

      if (!await file.exists()) {
        final Directory fileDir = new Directory(path);
        if (!await fileDir.exists()) return null;

        path = p.join(path, 'index.html');
        file = new File(path);

        if (!await file.exists()) {
          // TODO render directory listing
          return null;
        }
      }
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
    this.get(path, (_) => f.openRead(),
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType ?? MimeType.ofFile(f) ?? kDefaultMimeType,
        charset: kDefaultCharset,
        headers: headers);
  }

  /// Builds handlers to be served
  List<RequestHandler> _buildHandlers() {
    final ret = <RequestHandler>[];
    for (dynamic handler in _unbuiltRoutes) {
      if (handler is RequestHandler) {
        ret.add(handler);
      } else if (handler is RouteBuilder) {
        final Route jRoute = handler.routeInfo;

        if (handler.interceptors.length == 0 &&
            handler.exceptionHandlers.length == 0) {
          ret.add(simpleHandler(jRoute, '', handler.handler));
        } else {
          ret.add(new RouteChain(jRoute, '', handler.handler,
              handler.interceptors, handler.exceptionHandlers));
        }
      }
    }
    return ret;
  }
}
