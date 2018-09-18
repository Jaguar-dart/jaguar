part of jaguar.src.annotations;

typedef String WsResultProcessor(dynamic response);

/// Function that modifies [response]
typedef void ResponseProcessor(Response response);

/// [ResponseProcessor] to encode response value to json and also set mimetype
/// to [MimeType.json].
void jsonResponseProcessor(Response resp) {
  resp.headers.mimeType = MimeTypes.json;
  resp.value = converters.json.encode(resp.value);
}

/// Annotation to declare a method as request handler method that processes GET
/// requests.
class Get extends HttpMethod {
  const Get(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['GET'];
}

/// Annotation to declare a method as request handler method that processes POST
/// requests.
class Post extends HttpMethod {
  const Post(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['POST'];
}

/// Annotation to declare a method as request handler method that processes PUT
/// requests.
class Put extends HttpMethod {
  const Put(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['PUT'];
}

/// Annotation to declare a method as request handler method that processes DELETE
/// requests.
class Delete extends HttpMethod {
  const Delete(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['DELETE'];
}

/// Annotation to declare a method as request handler method that processes
/// PATCH requests.
class Patch extends HttpMethod {
  const Patch(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['PATCH'];
}

/// Annotation to declare a method as request handler method that processes
/// OPTIONS requests.
class OptionsMethod extends HttpMethod {
  const OptionsMethod(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['OPTIONS'];
}

/// Annotation to declare a method as request handler method that processes GET
/// requests with JSON response.
class GetJson extends Get {
  const GetJson(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes PUT
/// requests with JSON response.
class PutJson extends Put {
  const PutJson(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes POST
/// requests with JSON response.
class PostJson extends Post {
  const PostJson(
      {String path: '',
      Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes DELETE
/// requests with JSON response.
class DeleteJson extends Delete {
  const DeleteJson(
      {String path: '',
      final Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes GET
/// requests with HTML response.
class GetHtml extends Get {
  const GetHtml(
      {String path: '',
      final Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType,
      String charset: kDefaultCharset,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            pathRegEx: pathRegEx,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            responseProcessor: responseProcessor);
}

///An annotation to define a route
class HttpMethod {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods;

  /// Map of regular expression matchers for specific path segment
  final Map<String, String> pathRegEx;

  final int statusCode;

  final String mimeType;

  final String charset;

  final ResponseProcessor responseProcessor;

  const HttpMethod(
      {this.path: '',
      this.methods: _methods,
      this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset,
      this.responseProcessor});

  HttpMethod cloneWith(
          {String path,
          List<String> methods,
          Map<String, String> pathRegEx,
          int statusCode,
          String mimeType,
          String charset: kDefaultCharset,
          ResponseProcessor responseProcessor}) =>
      HttpMethod(
          path: path ?? this.path,
          methods: methods ?? this.methods,
          pathRegEx: pathRegEx ?? this.pathRegEx,
          statusCode: statusCode ?? this.statusCode,
          mimeType: mimeType ?? this.mimeType,
          charset: charset ?? this.charset,
          responseProcessor: responseProcessor ?? this.responseProcessor);

  static const List<String> _methods = const <String>['*'];

  String toString() => '$methods $path';
}

const String kDefaultMimeType = 'text/plain';
const String kDefaultCharset = 'utf-8';
