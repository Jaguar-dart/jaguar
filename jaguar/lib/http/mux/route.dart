part of jaguar.mux;

/// A function that shall be called when an exception occurs when processing a
/// route.
///
/// [exception] is the exception that occurred. [trace] is the stack trace is the
/// of the exception.
typedef FutureOr<dynamic> ExceptionHandler(
    Context ctx, exception, StackTrace trace);

/// Prototype of route interceptor. A router interceptor is a function that runs
/// before or after the route handler.
typedef FutureOr<Result> RouteInterceptor<Result>(Context ctx);

/// An interceptor based on Dart class.
///
/// NOTE: Same instance of [Interceptor] shall not be used for
/// multiple requests if it stores state in its members!
abstract class Interceptor<Result> {
  const Interceptor();

  FutureOr<Result> call(Context ctx);
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

  final List<RouteInterceptor> _before;

  final List<RouteInterceptor> _after;

  final List<ExceptionHandler> _onException;

  final _pathVarMapping = <String, int>{};

  int _pathGlobVarMapping;

  String _pathGlobVarName;

  Route.fromInfo(this.info, this.handler,
      {List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException})
      : pathSegments = pathToSegments(info.path),
        _before = before ?? [],
        _after = after ?? [],
        _onException = onException ?? [] {
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
          {List<String> methods = const <String>['*'],
          Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          HttpMethod(
              path: path,
              methods: methods,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for GET method requests
  factory Route.get(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Get(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for POST method requests
  factory Route.post(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Post(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for PUT method requests
  factory Route.put(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Put(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for DELETE method requests
  factory Route.delete(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Delete(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for PATCH method requests
  factory Route.patch(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          Patch(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for OPTIONS method requests
  factory Route.options(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          OptionsMethod(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for HTML requests
  factory Route.html(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType = MimeTypes.html,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          GetHtml(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests
  factory Route.json(String path, RouteHandler handler,
          {List<String> methods = const <String>[
            'GET',
            'PUT',
            'POST',
            'DELETE'
          ],
          Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor = jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          HttpMethod(
              path: path,
              methods: methods,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with GET method
  factory Route.getJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor = jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          GetJson(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with POST method
  factory Route.postJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor = jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          PostJson(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with PUT method
  factory Route.putJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor = jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          PutJson(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before,
          after: after,
          onException: onException);

  /// Constructs a [Route] for JSON requests with DELETE method
  factory Route.deleteJson(String path, RouteHandler handler,
          {Map<String, String> pathRegEx,
          int statusCode = 200,
          String mimeType,
          String charset = kDefaultCharset,
          ResponseProcessor responseProcessor = jsonResponseProcessor,
          List<RouteInterceptor> after,
          List<RouteInterceptor> before,
          List<ExceptionHandler> onException}) =>
      Route.fromInfo(
          DeleteJson(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
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
      Route.fromInfo(
          info.cloneWith(
              path: path,
              pathRegEx: pathRegEx,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              responseProcessor: responseProcessor),
          handler,
          before: before ?? this._before,
          after: after ?? this._after,
          onException: onException ?? this._onException);

  final Iterable<String> pathSegments;

  /// Handles requests
  Future<void> call(Context ctx) {
    ctx.route = this;

    ctx.before.addAll(_before);
    ctx.after.addAll(_after);
    ctx.onException.addAll(_onException);

    for (String pathParam in _pathVarMapping.keys) {
      ctx.pathParams[pathParam] = ctx.pathSegments[_pathVarMapping[pathParam]];
    }
    if (_pathGlobVarMapping != null) {
      ctx.pathParams[_pathGlobVarName] =
          ctx.pathSegments.skip(_pathGlobVarMapping).join('/');
    }

    return ctx.execute();
  }

  /// Add [interceptor] and optionally [interceptors] to be executed before
  /// [handler] in the route chain.
  void before(RouteInterceptor interceptor,
      [List<RouteInterceptor> interceptors]) {
    _before.add(interceptor);
    if (interceptors != null) _before.addAll(interceptors);
  }

  /// Add [interceptor] and optionally [interceptors] to be executed after
  /// [handler] in the route chain.
  void after(RouteInterceptor interceptor,
      [List<RouteInterceptor> interceptors]) {
    _after.add(interceptor);
    if (interceptors != null) _after.addAll(interceptors);
  }

  /// Add [exceptHandler] and optionally [exceptHandlers] to be executed after
  /// [handler] in the route chain.
  void onException(ExceptionHandler exceptHandler,
      [List<ExceptionHandler> exceptHandlers]) {
    _onException.add(exceptHandler);
    if (exceptHandlers != null) _onException.addAll(exceptHandlers);
  }

  /// Helps while debugging in variables window
  String toString() => '${info.methods} ${info.path}';
}
