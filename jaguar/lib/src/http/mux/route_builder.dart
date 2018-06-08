part of jaguar.mux;

/// Prototype of route exception handler
typedef FutureOr<void> ExceptionHandler<ET>(
    Context ctx, ET exception, StackTrace trace);

/// Prototype of route interceptor function that can run before or after the
/// route handler. The return value will be ignored.
typedef FutureOr<dynamic> RouteInterceptor(Context ctx);

/// Prototype for Route handler
typedef FutureOr<RespType> RouteHandler<RespType>(Context ctx);

/// Constructs a [Route] for GET method requests
Route get(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.get(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for POST method requests
Route post(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.post(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for PUT method requests
Route put(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.put(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for DELETE method requests
Route delete(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.delete(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for OPTIONS method requests
Route options(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.options(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for HTML requests
Route html(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.html(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for JSON requests
Route jsonMethod(RouteHandler handler,
        {String path,
        List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.json(path, handler,
        methods: methods,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for JSON requests with GET method
Route getJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.getJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for JSON requests with POST method
Route postJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.postJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for JSON requests with PUT method
Route putJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.putJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Constructs a [Route] for JSON requests with DELETE method
Route deleteJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor,
        List<RouteInterceptor> before: const [],
        List<RouteInterceptor> after: const [],
        List<ExceptionHandler> onException: const []}) =>
    new Route.deleteJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);

/// Helps builds a route handler with its interceptors and exception handlers
class Route implements RequestHandler {
  final HttpMethod info;

  /// The route handler function
  RouteHandler handler;

  final List<RouteInterceptor> before;

  final List<RouteInterceptor> after;

  final List<ExceptionHandler> onException;

  Route.fromInfo(this.info, this.handler,
      {this.after: const [], this.before: const [], this.onException: const []})
      : pathSegments = splitPathToSegments(info.path);

  /// Constructs a [Route]
  Route(String path, this.handler,
      {List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new HttpMethod(
            path: path,
            methods: methods,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for GET method requests
  Route.get(String path, this.handler,
      {int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new Get(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for POST method requests
  Route.post(String path, this.handler,
      {int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new Post(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for PUT method requests
  Route.put(String path, this.handler,
      {int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new Put(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for DELETE method requests
  Route.delete(String path, this.handler,
      {int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new Delete(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for PATCH method requests
  Route.patch(String path, this.handler,
      {int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new HttpMethod(
            path: path,
            methods: ['PATCH'],
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for OPTIONS method requests
  Route.options(String path, this.handler,
      {int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new OptionsMethod(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for HTML requests
  Route.html(String path, this.handler,
      {int statusCode: 200,
      String mimeType: MimeType.html,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new GetHtml(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for JSON requests
  Route.json(String path, this.handler,
      {List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new HttpMethod(
            path: path,
            methods: methods,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for JSON requests with GET method
  Route.getJson(String path, this.handler,
      {int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new GetJson(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for JSON requests with POST method
  Route.postJson(String path, this.handler,
      {int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new PostJson(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for JSON requests with PUT method
  Route.putJson(String path, this.handler,
      {int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new PutJson(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Constructs a [Route] for JSON requests with DELETE method
  Route.deleteJson(String path, this.handler,
      {int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : info = new DeleteJson(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor),
        pathSegments = splitPathToSegments(path);

  /// Clones this [Route] with the new values if provided
  Route cloneWith(
          {String path,
          int statusCode,
          String mimeType,
          String charset,
          Map<String, String> headers,
          Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteInterceptor> after: const [],
          List<RouteInterceptor> before: const [],
          List<ExceptionHandler> onException: const []}) =>
      new Route.fromInfo(
          info.cloneWith(
              path: path,
              statusCode: statusCode,
              mimeType: mimeType,
              charset: charset,
              headers: headers,
              pathRegEx: pathRegEx,
              responseProcessor: responseProcessor),
          handler,
          before: before ?? this.before,
          after: after ?? this.after,
          onException: onException ?? this.onException);

  final List<String> pathSegments;

  /// Handles requests
  Future<void> handleRequest(Context ctx) async {
    // TODO add prefix
    if (!matchPath(ctx.method, ctx.pathSegments, info.methods, pathSegments,
        info.pathRegEx, ctx.pathParams)) return null;
    try {
      ctx.before.addAll(before);
      ctx.after.addAll(after);
      ctx.onException.addAll(onException);
      await Do.chain(ctx, handler, info);
      return null;
    } catch (e, s) {
      for (int i = ctx.onException.length - 1; i >= 0; i--) {
        await ctx.onException[i](ctx, e, s);
      }
      rethrow;
    }
  }

  Route intercept(RouteInterceptor interceptor) {
    before.add(interceptor);
    return this;
  }

  Route interceptAfter(RouteInterceptor interceptor) {
    after.add(interceptor);
    return this;
  }

  /// Helps while debugging in variables window
  String toString() => '${info.methods} ${info.path}';
}

/// Returns if this route matches the given request path and method
bool matchPath(
    String method,
    List<String> path,
    List<String> myMethods,
    List<String> myPath,
    Map<String, String> pathRegEx,
    Map<String, dynamic> params) {
  if (!myMethods.contains(method)) return false;

  final int length = myPath.length;
  if (length != path.length) {
    if (length == 0) return false;
    if (path.length == 0) {
      if (length == 1 && myPath.first.endsWith('*')) return true;
      return false;
    }
    if (!myPath.last.endsWith('*')) return false;
  }

  for (int index = 0; index < length; index++) {
    final String current = myPath[index];
    final String actCurrent = path[index];
    if (current[0] == ':') {
      // TODO move this to generator side
      if (current.length < 2) {
        throw new Exception("Invalid URL parameter specification!");
      }

      if (current.endsWith('*')) {
        params[current.substring(1, current.length - 1)] =
            path.sublist(index).join('/');
        break;
      }

      final String argName = current.substring(1);

      if (pathRegEx is Map) {
        final String regExPtn = pathRegEx[argName];

        if (regExPtn != null) {
          RegExp regExp = new RegExp(regExPtn);

          Iterable<Match> matches = regExp.allMatches(actCurrent);
          if (matches.isEmpty) return false;
        }
      }
      params[argName] = actCurrent;
    } else if (current == '*') {
      if (index == length - 1) return true;
    } else {
      if (current != actCurrent) return false;
    }
  }

  return true;
}
