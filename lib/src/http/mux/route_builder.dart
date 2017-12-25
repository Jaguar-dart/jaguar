part of jaguar.mux;

/// Helps builds a route handler with its interceptors and exception handlers
class RouteBuilder {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods;

  /// Default status code for the route response
  final int statusCode;

  /// Default mime-type for route response
  final String mimeType;

  /// Default charset for route response
  final String charset;

  /// Default headers for route response
  final Map<String, String> headers;

  /// Regex for the route path
  final Map<String, String> pathRegEx;

  /// The route handler function
  final RouteFunc handler;

  /// Constructs a [RouteBuilder]
  RouteBuilder(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers});

  /// Constructs a [RouteBuilder] for GET method requests
  RouteBuilder.get(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['GET'];

  /// Constructs a [RouteBuilder] for POST method requests
  RouteBuilder.post(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['POST'];

  /// Constructs a [RouteBuilder] for PUT method requests
  RouteBuilder.put(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['PUT'];

  /// Constructs a [RouteBuilder] for DELETE method requests
  RouteBuilder.delete(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['DELETE'];

  /// Constructs a [RouteBuilder] for PATCH method requests
  RouteBuilder.patch(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['PATCH'];

  /// Constructs a [RouteBuilder] for OPTIONS method requests
  RouteBuilder.options(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['OPTIONS'];

  /// Constructs a [RouteBuilder] for HTML requests
  RouteBuilder.html(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['GET'],
        mimeType = 'text/html';

  /// Constructs a [RouteBuilder] for JSON requests
  RouteBuilder.json(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers})
      : mimeType = 'application/json';

  /// Constructs a [RouteBuilder] for JSON requests with GET method
  RouteBuilder.getJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['GET'],
        mimeType = 'application/json';

  /// Constructs a [RouteBuilder] for JSON requests with POST method
  RouteBuilder.postJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['POST'],
        mimeType = 'application/json';

  /// Constructs a [RouteBuilder] for JSON requests with PUT method
  RouteBuilder.putJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['PUT'],
        mimeType = 'application/json';

  /// Constructs a [RouteBuilder] for JSON requests with DELETE method
  RouteBuilder.deleteJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers})
      : methods = ['DELETE'],
        mimeType = 'application/json';

  /// Interceptors wrapped around the [handler]
  final _interceptors = <InterceptorCreator>[];

  /// Exception handlers for the [handler]
  final _exceptionHandlers = <ExceptionHandler>[];

  /// Interceptors
  UnmodifiableListView<InterceptorCreator> get interceptors =>
      new UnmodifiableListView<InterceptorCreator>(_interceptors);

  /// Exception handlers
  UnmodifiableListView<ExceptionHandler> get exceptionHandlers =>
      new UnmodifiableListView<ExceptionHandler>(_exceptionHandlers);

  /// Wraps a single [interceptor] around the [handler]
  RouteBuilder wrap(InterceptorCreator interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  /// Wraps all of the given [interceptors] around the [handler]
  RouteBuilder wrapAll(List<InterceptorCreator> interceptors) {
    this._interceptors.addAll(interceptors);
    return this;
  }

  /// Registers the given [exceptionHandler] for the [handler]
  RouteBuilder onException(ExceptionHandler exceptionHandler) {
    _exceptionHandlers.add(exceptionHandler);
    return this;
  }

  /// Registers all of the given [exceptionHandler] for the [handler]
  RouteBuilder onExceptionAll(List<ExceptionHandler> exceptionHandlers) {
    _exceptionHandlers.addAll(exceptionHandlers);
    return this;
  }

  /// Clones this [RouteBuilder] with the [newPath] as [path]
  RouteBuilder cloneWithPath(String newPath) =>
      new RouteBuilder(newPath, handler,
          methods: methods,
          pathRegEx: this.pathRegEx,
          statusCode: this.statusCode,
          mimeType: this.mimeType,
          charset: this.charset,
          headers: this.headers);
}
