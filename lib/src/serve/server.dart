part of jaguar.src.serve;

/// Base class for Request handlers
abstract class RequestHandler {
  Future<Response> handleRequest(Context ctx, {String prefix});
}

/// The Jaguar server
///
/// It servers the provided APIs on the given `address` and `port`
/// `securityContext``is used to add HTTPS support
class Jaguar {
  /// Address on which the API is serviced
  final String address;

  /// Port on which the API is serviced
  final int port;

  /// Security context
  final SecurityContext securityContext;

  /// Should the port be servicable from multiple isolates
  final bool multiThread;

  /// Should the response be auto-compressed
  final bool autoCompress;

  /// Base path
  final String basePath;

  HttpServer _server;

  final ErrorWriter errorWriter;

  /// Logger
  final Logger log = new Logger('J');

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
      this.errorWriter: const HtmlErrorWriter()});

  /// Starts serving the provided APIs
  Future<Null> serve() async {
    if (_server != null) throw new Exception('Already serving!');
    log.severe("Running on $resourceName");
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
    log.info("Req => Method: ${request.method} Url: ${request.uri}");
    final ctx = new Context(new Request(request, log));
    ctx.addInterceptors(_interceptorCreators);
    try {
      Response response;
      for (RequestHandler requestHandler in _builtHandlers) {
        response = await requestHandler.handleRequest(ctx, prefix: basePath);
        if (response is Response) {
          break;
        }
      }
      if (response is Response) {
        await response.writeResponse(request.response);
      } else {
        throw new NotFoundError("The path ${request.uri.path} is not found!");
      }
    } catch (e, stack) {
      log.severe(
          "ReqErr => Method: ${request.method} Url: ${request.uri} E: $e Stack: $stack");
      final Response resp =
          errorWriter.writeError(request.uri.toString(), e, stack, 500);
      await resp.writeResponse(request.response);
    } finally {
      await request.response.close();
    }
  }

  final _interceptorCreators = <InterceptorCreator>[];

  UnmodifiableListView<InterceptorCreator> get interceptorCreators =>
      new UnmodifiableListView<InterceptorCreator>(_interceptorCreators);

  final _builtHandlers = <RequestHandler>[];

  /// [RequestHandler]s
  final List<RequestHandler> _apis = <RequestHandler>[];

  /// Adds given API [api] to list of API that will be served
  void addApi(RequestHandler api) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }
    _apis.add(api);
  }

  // Adds give Api class using reflection
  void addApiReflected(api) => addApi(new JaguarReflected(api));

  final _unbuiltRoutes = <RouteBuilder>[];

  /// Adds the [route] to be served
  RouteBuilder addRoute(RouteBuilder route) {
    if (_server != null) {
      throw new Exception('Cannot add routes after server has been started!');
    }

    _unbuiltRoutes.add(route);
    return route;
  }

  /// Add a route to be served
  RouteBuilder route(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE']}) {
    final route =
        new RouteBuilder(path, handler, pathRegEx: pathRegEx, methods: methods);
    return addRoute(route);
  }

  /// Add a route with GET method to be served
  RouteBuilder get(String path, RouteFunc handler,
      {Map<String, String> pathRegEx}) {
    final route = new RouteBuilder.get(path, handler, pathRegEx: pathRegEx);
    return addRoute(route);
  }

  /// Add a route with POST method to be served
  RouteBuilder post(String path, Function handler,
      {Map<String, String> pathRegEx}) {
    final route = new RouteBuilder.post(path, handler, pathRegEx: pathRegEx);
    return addRoute(route);
  }

  /// Add a route with PUT method to be served
  RouteBuilder put(String path, Function handler,
      {Map<String, String> pathRegEx}) {
    final route = new RouteBuilder.put(path, handler, pathRegEx: pathRegEx);
    return addRoute(route);
  }

  /// Add a route with DELETE method to be served
  RouteBuilder delete(String path, Function handler,
      {Map<String, String> pathRegEx}) {
    final route = new RouteBuilder.delete(path, handler, pathRegEx: pathRegEx);
    return addRoute(route);
  }

  /// Add a route with PATCH method to be served
  RouteBuilder patch(String path, Function handler,
      {Map<String, String> pathRegEx}) {
    final route = new RouteBuilder.patch(path, handler, pathRegEx: pathRegEx);
    return addRoute(route);
  }

  /// Add a route with OPTIONS method to be served
  RouteBuilder options(String path, Function handler,
      {Map<String, String> pathRegEx}) {
    final route = new RouteBuilder.options(path, handler, pathRegEx: pathRegEx);
    return addRoute(route);
  }

  /// Create a new route group
  GroupBuilder group([String path = '']) {
    return new GroupBuilder(this, path: path);
  }

  /// Builds handlers to be served
  void _buildHandlers() {
    _builtHandlers.clear();
    _builtHandlers.addAll(_apis);
    for (RouteBuilder route in _unbuiltRoutes) {
      Route jRoute = new Route(
          path: route.path, methods: route.methods, pathRegEx: route.pathRegEx);
      _builtHandlers.add(new ReflectedRoute.build(route.handler, jRoute, '',
          route.interceptors, route.exceptionHandlers));
    }
  }
}
