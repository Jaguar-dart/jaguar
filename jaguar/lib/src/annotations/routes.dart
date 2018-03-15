part of jaguar.src.annotations;

/// Annotation to declare a method as request handler method that processes GET
/// requests.
class Get extends Route {
  const Get(
      {String path,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['GET'];
}

/// Annotation to declare a method as request handler method that processes POST
/// requests.
class Post extends Route {
  const Post(
      {String path,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['POST'];
}

/// Annotation to declare a method as request handler method that processes PUT
/// requests.
class Put extends Route {
  const Put(
      {String path,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['PUT'];
}

/// Annotation to declare a method as request handler method that processes DELETE
/// requests.
class Delete extends Route {
  const Delete(
      {String path,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor})
      : super(
            path: path,
            methods: _methods,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);

  static const List<String> _methods = const <String>['DELETE'];
}

/// Annotation to declare a method as request handler method that processes GET
/// requests with JSON response.
class GetJson extends Get {
  const GetJson(
      {String path,
      int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      final Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes PUT
/// requests with JSON response.
class PutJson extends Put {
  const PutJson(
      {String path,
      int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      final Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes POST
/// requests with JSON response.
class PostJson extends Post {
  const PostJson(
      {String path,
      int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      final Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes DELETE
/// requests with JSON response.
class DeleteJson extends Delete {
  const DeleteJson(
      {String path,
      int statusCode: 200,
      String mimeType: MimeType.json,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      final Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor})
      : super(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx,
            responseProcessor: responseProcessor);
}

/// Annotation to declare a method as request handler method that processes GET
/// requests with HTML response.
class GetHtml extends Get {
  const GetHtml(
      {String path,
      int statusCode: 200,
      String mimeType: MimeType.html,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      final Map<String, String> pathRegEx})
      : super(
            path: path,
            statusCode: statusCode,
            mimeType: mimeType,
            charset: charset,
            headers: headers,
            pathRegEx: pathRegEx);
}

///An annotation to define a route
class Route extends RouteBase {
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

  /// Map of regular expression matchers for specific path segment
  final Map<String, String> pathRegEx;

  final ResponseProcessor responseProcessor;

  const Route(
      {this.path,
      this.methods: _methods,
      this.statusCode: 200,
      this.mimeType: kDefaultMimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.pathRegEx,
      this.responseProcessor});

  static const List<String> _methods = const <String>[
    'GET',
    'POST',
    'PUT',
    'PATCH',
    'DELETE',
    'OPTIONS'
  ];
}

const String kDefaultMimeType = 'text/plain';
const String kDefaultCharset = 'utf-8';

/// Function type for a route handler
typedef FutureOr<dynamic> RouteFunc<RespType>(Context ctx);

/// Function type for a route handler
typedef FutureOr<Response<RespType>> RouteHandlerFunc<RespType>(Context ctx);

typedef dynamic ResponseProcessor(dynamic resp);

dynamic jsonResponseProcessor(dynamic value) => converters.json.encode(value);

/// Base class for route specification
abstract class RouteBase {
  const RouteBase();

  /// Path of the route
  String get path;

  /// Methods handled by the route
  List<String> get methods;

  /// Default status code for the route response
  int get statusCode;

  /// Default mime-type for route response
  String get mimeType;

  /// Default charset for route response
  String get charset;

  /// Default headers for route response
  Map<String, String> get headers;

  /// Map of regular expression matchers for specific path segment
  Map<String, String> get pathRegEx;

  ResponseProcessor get responseProcessor;

  /// Returns path with provided prefix
  String prefixedPath(String prefix) => '' + (prefix ?? '') + (path ?? '');

  /// Returns if this route matches the given request path and method
  bool match(String requestPath, String method, String prefix,
      Map<String, dynamic> params) {
    params.clear();

    if (!methods.contains(method)) {
      return false;
    }

    List<String> rqSegs = splitPathToSegments(requestPath);

    List<String> segs = splitPathToSegments(prefixedPath(prefix));

    return comparePathSegments(segs, rqSegs, params);
  }

  bool comparePathSegments(
      List<String> template, List<String> actual, Map<String, dynamic> args) {
    if (template.length != actual.length &&
        template.length != 0 &&
        !template.last.endsWith('*')) {
      return false;
    }

    for (int index = 0; index < template.length; index++) {
      if (template[index].isNotEmpty && template[index][0] == ':') {
        //TODO move this to generator side
        if (template[index].length < 2) {
          throw new Exception("Invalid URL parameter specification!");
        }

        final String argName = template[index].substring(1);

        if (argName.endsWith('*')) {
          args[argName.substring(0, argName.length - 1)] =
              actual.sublist(index).join('/');
          break;
        }

        //TODO move this to generator side
        {
          //TODO check that argName is valid Dart variable name
        }

        if (pathRegEx is Map) {
          final String regExPtn = pathRegEx[argName];

          if (regExPtn is! String) {
            continue;
          }

          RegExp regExp = new RegExp(regExPtn);

          Iterable<Match> matches = regExp.allMatches(actual[index]);
          if (matches.isEmpty) {
            return false;
          }
        }

        args[argName] = actual[index];
      } else if (template[index] == '*') {
        return true;
      } else {
        if (template[index] != actual[index]) {
          return false;
        }
      }
    }

    return true;
  }
}
