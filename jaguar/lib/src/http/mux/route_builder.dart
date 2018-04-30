part of jaguar.mux;

/// Constructs a [Route] for GET method requests
Route get(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor,
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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
        List<RouteFunc> before: const [],
        List<RouteFunc> after: const [],
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

  final List<RouteFunc> before;

  final List<RouteFunc> after;

  final List<ExceptionHandler> onException;

  Route.fromInfo(this.info, this.handler,
      {this.after: const [],
      this.before: const [],
      this.onException: const []});

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

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
            responseProcessor: responseProcessor);

  /// Clones this [Route] with the new values if provided
  Route cloneWith(
          {String path,
          int statusCode,
          String mimeType,
          String charset,
          Map<String, String> headers,
          Map<String, String> pathRegEx,
          ResponseProcessor responseProcessor,
          List<RouteFunc> after: const [],
          List<RouteFunc> before: const [],
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

  /// Handles requests
  Future<void> handleRequest(Context ctx, {String prefix: ''}) async {
    if (!info.match(ctx.path, ctx.method, prefix, ctx.pathParams)) return null;
    try {
      ctx.before.addAll(before);
      ctx.after.addAll(after);
      ctx.onException.addAll(onException);
      await Do.chain(ctx, handler, info);
      return null;
    } catch (e, s) {
      for (int i = ctx.onException.length - 1; i >= 0; i++) {
        await ctx.onException[i](ctx, e, s);
      }
      rethrow;
    }
  }

  /// Helps while debugging in variables window
  String toString() => '${info.methods} ${info.path}';
}
