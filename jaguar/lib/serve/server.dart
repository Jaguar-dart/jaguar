library jaguar.src.serve;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

import 'package:logging/logging.dart';

import 'package:jaguar/serve/error_writer/error_writer.dart';
import 'package:path_tree/path_tree.dart';

export 'package:jaguar/serve/error_writer/error_writer.dart';

/// Creates a Jaguar HTTP server.
///
///     Future<void> main() async {
///       final server = Jaguar();
///       server.get('/', (ctx) => 'Hello world!')
///       await server.serve();
///     }
class Jaguar extends Object with Muxable {
  final List<ConnectTo> _connectionInfos;

  /// Should the response be auto-compressed?
  ///
  /// Defaults to false.
  bool autoCompress;

  /// Used to write error pages in case of HTTP errors.
  ///
  /// Defaults to [DefaultErrorWriter].
  ErrorWriter errorWriter;

  /// Session manager to parse and update session data for requests.
  ///
  /// Defaults to [JaguarSessionManager].
  SessionManager? sessionManager;

  final before = <RouteInterceptor>[];

  final after = <RouteInterceptor>[];

  final onException = <ExceptionHandler>[];

  /// Logger used to log concise useful information about the request. This is
  /// also available in [Context] so that interceptors and route handlers can also
  /// log.
  final log = Logger('J');

  final FutureOr<void> Function(Context ctx)? onRouteServed;

  /// Internal http server
  List<HttpServer>? _servers;

  /// Constructs an instance of [Jaguar] with given configuration.
  ///
  /// [address]:[port] is the address and port at which the HTTP requests are
  /// listened.
  /// [multiThread] determines if the port can be serviced from multiple isolates.
  /// [securityContext] is used to configure HTTPS support.
  /// [autoCompress] determines if the response should be automatically compressed.
  /// [errorWriter] is used to write custom error page [Response] in cases of HTTP
  /// errors.
  /// [sessionManager] provides ability to use custom session managers.
  Jaguar({
    String address = "0.0.0.0",
    int port = 8080,
    bool multiThread = false,
    SecurityContext? securityContext,
    this.autoCompress = false,
    ErrorWriter? errorWriter,
    this.sessionManager,
    this.onRouteServed,
  })  : errorWriter = errorWriter ?? DefaultErrorWriter(),
        _connectionInfos = [
          ConnectTo(
              address: address,
              port: port,
              securityContext: securityContext,
              multiThread: multiThread)
        ];

  Iterable<HttpServer> get servers => List.unmodifiable(_servers!);

  /// Start listening for requests also on [connection]
  void alsoTo(ConnectTo connection) {
    if (_servers != null) throw Exception('Already started!');
    _connectionInfos.add(connection);
  }

  /// Starts serving the requests.
  Future<void> serve(
      {bool logRequests = false,
      Duration? idleTimeout,
      int sessionTimeout = 1200}) async {
    if (_servers != null) {
      throw Exception('Already started!');
    }

    _build();

    if (logRequests) {
      log.info("Serving on " + _connectionInfos.join(', '));
    }

    _servers = <HttpServer>[];
    try {
      for (int i = 0; i < _connectionInfos.length; i++) {
        ConnectTo ct = _connectionInfos[i];
        HttpServer server;
        if (ct.securityContext != null) {
          server = await HttpServer.bindSecure(
              ct.address, ct.port, ct.securityContext!,
              shared: ct.multiThread);
          server.idleTimeout = idleTimeout;
          server.sessionTimeout = sessionTimeout;
        } else {
          server = await HttpServer.bind(ct.address, ct.port,
              shared: ct.multiThread);
          server.idleTimeout = idleTimeout;
          server.sessionTimeout = sessionTimeout;
        }
        server.autoCompress = autoCompress;
        _servers!.add(server);
      }
    } catch (e) {
      try {
        await close();
      } catch (e) {
        // ignore error
      }
      rethrow;
    }

    for (HttpServer server in _servers!) {
      if (logRequests) {
        server.listen((HttpRequest r) {
          log.info("Req => Method: ${r.method} Url: ${r.uri}");
          _handler(r);
        });
      } else {
        server.listen(_handler);
      }
    }
  }

  Future<void> restart({bool logRequests = false}) async {
    await close();
    return serve(logRequests: logRequests);
  }

  Future<void> _handler(HttpRequest request) async {
    dynamic maybeFuture;
    final ctx = Context(Request(request),
        sessionManager: sessionManager,
        log: log,
        userFetchers: userFetchers,
        before: before.toList(),
        after: after.toList(),
        onException: onException.toList());

    // Try to find a matching route and invoke it.
    Route? handler = _routeTree.match(request.uri.pathSegments, request.method);

    if (handler == null) {
      ctx.response = await errorWriter.make404(ctx);
    } else {
      try {
        await handler(ctx);
      } catch (e, stack) {
        try {
          if (e is Response) {
            ctx.response = e;
          } else if (e is ExceptionWithResponse) {
            ctx.response = e.response;
          } else {
            ctx.response = await errorWriter.make500(ctx, e, stack);
          }

          for (int i = ctx.onException.length - 1; i >= 0; i--) {
            try {
              var maybeFuture = ctx.onException[i](ctx, e, stack);
              if (maybeFuture is Future) await maybeFuture;
            } finally {}
          }
        } catch (e) {
          ctx.response =
              StringResponse(body: 'General technical error', statusCode: 500);
        }
      }
    }

    // Write response
    if (ctx.response is! SkipResponse) {
      try {
        // Update session, if required.
        if (ctx.sessionNeedsUpdate) {
          maybeFuture = ctx.sessionManager!.write(ctx);
          if (maybeFuture is Future) await maybeFuture;
        }

        await ctx.response.writeResponse(request.response);
        if (onRouteServed != null) {
          Future.microtask(() => onRouteServed!(ctx));
        }
      } catch (e, stack) {
        log.warning('${e.toString()}\n${stack.toString()}');
      }

      return request.response.close();
    }
  }

  /// Closes the server
  Future<void> close() async {
    if (_servers == null) {
      return;
    }

    dynamic err;
    for (HttpServer server in _servers!) {
      try {
        await server.close(force: true);
      } catch (e) {
        if (err == null) err = e;
      }
    }
    _servers = null;
    if (err != null) {
      throw err;
    }
  }

  /// Create a new route group
  GroupBuilder group([String path = '']) => GroupBuilder(this, path: path);

  /// Adds all the given [routes] to be served
  void add(Iterable<Route> routes) {
    if (_servers != null) throw Exception('Server has started!');
    _routes.addAll(routes);
  }

  /// Adds the given [route] to be served
  Route addRoute(Route route) {
    if (_servers != null) throw Exception('Server has started!');
    _routes.add(route);
    return route;
  }

  /// [RouteHandler]s
  final List<Route> _routes = [];

  final userFetchers = <Type, UserFetcher<AuthorizationUser>>{};

  PathTree<Route> _routeTree = PathTree<Route>();

  void _build() {
    _routeTree = PathTree<Route>();

    for (Route route in _routes) {
      _routeTree.addPathAsSegments(route.pathSegments, route,
          tags: route.info.methods, pathRegEx: route.info.pathRegEx);
    }
  }
}

class ConnectTo {
  /// Address on which the API is serviced
  final String address;

  /// Port on which the API is serviced
  final int port;

  /// Security context for HTTPS
  final SecurityContext? securityContext;

  /// Should the port be service-able from multiple isolates?
  ///
  /// Defaults to false.
  final bool multiThread;

  /// Base path
  String get authority => "$address:$port";

  ConnectTo(
      {this.address = "0.0.0.0",
      this.port = 8080,
      this.securityContext,
      this.multiThread = false});

  ConnectTo.https(this.securityContext,
      {this.address = "0.0.0.0", this.port = 443, this.multiThread = false});

  String toString() => authority;
}

abstract class ExceptionWithResponse {
  Response get response;
}
