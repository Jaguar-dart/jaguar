part of jaguar.src.serve;

/// Base class for Request handlers
abstract class RequestHandler {
  FutureOr<Response> handleRequest(Context ctx, {String prefix});
}

/// The Jaguar server
///
/// It servers the provided APIs on the given `address` and `port`
/// `securityContext``is used to add HTTPS support
class Jaguar extends Object with Muxable {
  /// Address on which the API is serviced
  final String address;

  /// Port on which the API is serviced
  final int port;

  /// Security context
  final SecurityContext securityContext;

  /// Should the port be service-able from multiple isolates
  final bool multiThread;

  /// Should the response be auto-compressed
  final bool autoCompress;

  /// Base path
  final String basePath;

  final ErrorWriter errorWriter;

  /// Session manager to parse and update session data for requests
  final SessionManager sessionManager;

  /// Logger
  final Logger log = new Logger('J');

  final DebugStream debugStream;

  HttpServer _server;

  /// Returns protocol string
  String get protocolStr => securityContext == null ? 'http' : 'https';

  /// Base path
  String get resourceName => "$protocolStr://$address:$port/";

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

  /// Starts serving the provided APIs
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
    _server.listen((HttpRequest request) => _handleRequest(request));
  }

  /// Closes the server
  Future<Null> close() async {
    await _server.close(force: true);
    _server = null;
    _builtHandlers.clear();
  }

  Future _handleRequest(HttpRequest request) async {
    final start = new DateTime.now();
    log.info("Req => Method: ${request.method} Url: ${request.uri}");
    final ctx = new Context(new Request(request, sessionManager, log));
    ctx.addInterceptors(_interceptorCreators);

    Response response;
    try {
      for (RequestHandler requestHandler in _builtHandlers) {
        response = await requestHandler.handleRequest(ctx, prefix: basePath);
        if (response is Response) {
          break;
        }
      }

      if (response is Response) {
        if (ctx.req.sessionNeedsUpdate)
          await sessionManager.write(ctx.req, response);
      }
    } catch (e, stack) {
      if (e is Response) {
        await e.writeResponse(request.response);
        debugStream?._add(new DebugInfo.make(ctx, e, start));
      } else if (e is ResponseError) {
        final Response resp = e.response(ctx);
        await resp.writeResponse(request.response);
        debugStream?._add(new DebugInfo.make(ctx, resp, start));
      } else {
        log.severe("ReqErr => Method: ${request.method} Url: ${request
                .uri} E: $e Stack: $stack");

        final Response resp = errorWriter.make500(ctx, e, stack);
        await resp.writeResponse(request.response);
        debugStream?._add(new DebugInfo.make(ctx, resp, start));
      }
      return request.response.close();
    }

    if (response is Response) {
      debugStream?._add(new DebugInfo.make(ctx, response, start));
    } else {
      response = errorWriter.make404(ctx);
    }

    try {
      await response.writeResponse(request.response);
    } catch (_) {}

    return request.response.close();
  }

  final _interceptorCreators = <InterceptorCreator>[];

  UnmodifiableListView<InterceptorCreator> get interceptorCreators =>
      new UnmodifiableListView<InterceptorCreator>(_interceptorCreators);

  /// Wraps interceptor creator around all routes
  void wrap(InterceptorCreator creator) => _interceptorCreators.add(creator);

  final _builtHandlers = <RequestHandler>[];

  final _unbuiltRoutes = <dynamic>[];

  /// Adds given API [api] to list of API that will be served
  void addApi(RequestHandler api) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _unbuiltRoutes.add(api);
  }

  // Adds give Api class using reflection
  void addApiReflected(api) => addApi(new JaguarReflected(api));

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
        Route jRoute = new Route(
            path: handler.path,
            methods: handler.methods,
            pathRegEx: handler.pathRegEx);
        _builtHandlers.add(new ReflectedRoute.build(handler.handler, jRoute, '',
            handler.interceptors, handler.exceptionHandlers));
      }
    }
  }
}

/// An exception that can make an error [Response]
abstract class ResponseError {
  /// Creates [Response] from error
  Response response(Context ctx);
}

class DebugInfo {
  DateTime time;

  Duration duration;

  String path;

  String method;

  final Map<String, List<String>> reqHeaders = <String, List<String>>{};

  int statusCode;

  final Map<String, List<String>> respHeaders = <String, List<String>>{};

  final List<String> messages = <String>[];

  DebugInfo();

  factory DebugInfo.make(Context ctx, Response resp, DateTime start) {
    final ret = new DebugInfo();
    ret.path = ctx.path;
    ret.method = ctx.method;
    ctx.req.headers.forEach(
        (String key, List<String> values) => ret.reqHeaders[key] = values);
    resp.headers.forEach(
        (String key, List<String> values) => ret.reqHeaders[key] = values);
    ret.statusCode = resp.statusCode;
    ret.time = start;
    ret.duration = new DateTime.now().difference(start);
    ret.messages.addAll(ctx.debugMsgs);
    return ret;
  }
}

class DebugStream {
  final StreamController<DebugInfo> _controller =
      new StreamController<DebugInfo>.broadcast();

  Stream<DebugInfo> get onRequest => _controller.stream;

  Stream<DebugInfo> get onError => onRequest.where(
      (DebugInfo info) => info.statusCode < 200 && info.statusCode > 299);

  void _add(DebugInfo info) {
    _controller.add(info);
  }
}
