part of jaguar.mux;

/// A function that shall be called when an exception occurs when processing a
/// route.
///
/// [exception] is the exception that occurred. [trace] is the stack trace is the
/// of the exception.
typedef FutureOr<void> ExceptionHandler<ET>(
    Context ctx, ET exception, StackTrace trace);

/// Prototype of route interceptor. A router interceptor is a function that runs
/// before or after the route handler.
typedef FutureOr<void> RouteInterceptor(Context ctx);

abstract class Interceptor {
  const Interceptor();

  FutureOr<void> call(Context ctx);
}

/// Prototype for Route handler. A route handler is a function that shall be
/// invoked when a HTTP request with matching path is received.
///
/// The [context] parameter contains information about the request. The route
/// handler is expected to process the request and return the response or result
/// of type [RespType]. Alternatively, one can set the response using response
/// member of [context].
typedef FutureOr<RespType> RouteHandler<RespType>(Context context);

/// Helps builds a route handler with its interceptors and exception handlers
class Route {
  final HttpMethod info;

  /// The route handler function
  RouteHandler handler;

  final List<RouteInterceptor> before;

  final List<RouteInterceptor> after;

  final List<ExceptionHandler> onException;

  final _pathVarMapping = <String, int>{};

  int _pathGlobVarMapping;

  String _pathGlobVarName;

  Route.fromInfo(this.info, this.handler,
      {List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException})
      : pathSegments = pathToSegments(info.path),
        before = before ?? [],
        after = after ?? [],
        onException = onException ?? [] {
    for (int i = 0; i < pathSegments.length; i++) {
      String seg = pathSegments.elementAt(i);
      if (seg.startsWith(':')) {
        if (i == pathSegments.length - 1 && seg.endsWith('*')) {
          _pathGlobVarMapping = i;
          _pathGlobVarName = seg.substring(1, seg.length - 1);
        } else {
          seg = seg.substring(1);
          if (seg.isNotEmpty) _pathVarMapping[seg] = i;
        }
      }
    }
  }

  /// Constructs a [Route]
  factory Route(String path, RouteHandler handler,
          {List<String> methods: const <String>['*'],
          Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          HttpMethod(
              path: path,
              methods: methods,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for GET method requests
  factory Route.get(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Get(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for POST method requests
  factory Route.post(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Post(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for PUT method requests
  factory Route.put(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Put(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for DELETE method requests
  factory Route.delete(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Delete(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for PATCH method requests
  factory Route.patch(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Patch(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for OPTIONS method requests
  factory Route.options(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          OptionsMethod(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for HTML requests
  factory Route.html(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor: htmlResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          GetHtml(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests
  factory Route.json(String path, RouteHandler handler,
          {List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
          Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor: jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          HttpMethod(
              path: path,
              methods: methods,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with GET method
  factory Route.getJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor: jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          GetJson(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with POST method
  factory Route.postJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor: jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          PostJson(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with PUT method
  factory Route.putJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor: jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          PutJson(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with DELETE method
  factory Route.deleteJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor: jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          DeleteJson(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Clones this [Route] with the new values if provided
  Route cloneWith(
          {String path,
          int statusCode,
          String mimeType,
          String charset,
          Map<String, String> headers,
          Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      new Route.fromInfo(
          info.cloneWith(
              path: path,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before ?? this.before,
          after: after ?? this.after,
          onException: onException ?? this.onException);

  final Iterable<String> pathSegments;

  /// Handles requests
  Future<void> call(Context ctx) {
    ctx.before.addAll(before);
    ctx.after.addAll(after);
    ctx.onException.addAll(onException);

    for (String pathParam in _pathVarMapping.keys) {
      ctx.pathParams[pathParam] = ctx.pathSegments[_pathVarMapping[pathParam]];
    }
    if (_pathGlobVarMapping != null) {
      ctx.pathParams[_pathGlobVarName] =
          ctx.pathSegments.skip(_pathGlobVarMapping).join('/');
    }

    return ctx.execute(handler, info.responseProcessor);
  }

  /// Helps while debugging in variables window
  String toString() => '${info.methods} ${info.path}';
}
