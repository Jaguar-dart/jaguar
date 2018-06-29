library jaguar.src.serve;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';

import 'package:jaguar/src/serve/error_writer/import.dart';

export 'package:jaguar/src/serve/error_writer/import.dart';

/// Base class for Request handlers
abstract class RequestHandler {
  FutureOr<void> handleRequest(Context ctx);
}

/// The Jaguar server
class Jaguar extends Object with Muxable {
  /// Address on which the API is serviced
  String address;

  /// Port on which the API is serviced
  int port;

  /// Security context for HTTPS
  SecurityContext securityContext;

  /// Should the port be service-able from multiple isolates?
  ///
  /// Defaults to false.
  bool multiThread;

  /// Should the response be auto-compressed?
  ///
  /// Defaults to false.
  bool autoCompress;

  /// Base path of the served api.
  ///
  /// Defaults to '' (Aka. No base path).
  String basePath;

  /// Used to write error pages in case of HTTP errors.
  ///
  /// Defaults to [DefaultErrorWriter].
  ErrorWriter errorWriter;

  /// Session manager to parse and update session data for requests.
  ///
  /// Defaults to [CookieSessionManager].
  SessionManager sessionManager;

  /// Logger used to log concise useful information about the request. This is
  /// also available in [Context] so that interceptors and route handlers can also
  /// log.
  Logger log = new Logger('J');

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

  Future<Null> restart({bool logRequests: false}) =>
      _server.close(force: true).then((_) {
        _server = null;
        return serve(logRequests: logRequests);
      });

  Future _handler(HttpRequest request) async {
    final ctx =
        new Context(new Request(request), sessionManager, log, userFetchers);
    ctx.prefix = basePath;

    try {
      // Try to find a matching route and invoke it.
      for (RequestHandler requestHandler in _handlers) {
        await requestHandler.handleRequest(ctx);
        if (ctx.response != null) break;
      }

      // If no response, write 404 error.
      if (ctx.response == null) {
        errorWriter.make404(ctx);
      }
    } catch (e, stack) {
      if (e is Response) {
        // If [Response] object was thrown, write it!
        ctx.response = e;
      } else {
        errorWriter.make500(ctx, e, stack);
      }
    }

    try {
      // Update session, if required.
      if (ctx.sessionNeedsUpdate) await sessionManager.write(ctx);
    } catch (_) {}

    // Write response
    try {
      await ctx.response.writeResponse(request.response);
    } catch (_) {}

    return request.response.close();
  }

  /// Closes the server
  Future<Null> close() async {
    await _server.close(force: true);
    _server = null;
  }

  /// [RequestHandler]s
  final List<RequestHandler> _handlers = [];

  /// Adds the given [RequestHandler] to be served
  void add(RequestHandler api) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _handlers.add(api);
  }

  /// Adds the [Route] to be served
  Route addRoute(Route route) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _handlers.add(route);
    return route;
  }

  /// Create a new route group
  GroupBuilder group([String path = '']) => new GroupBuilder(this, path: path);

  final userFetchers = <Type, UserFetcher<AuthorizationUser>>{};
}
