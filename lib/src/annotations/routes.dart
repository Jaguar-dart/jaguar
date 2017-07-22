part of jaguar.src.annotations;

const String _kDefaultContentType = 'text/plain; charset=utf-8';
const String kDefaultMimeType = 'text/plain';
const String kDefaultCharset = 'utf-8';

/// Function type for a route handler
typedef FutureOr<dynamic> RouteFunc<RespType>(Context ctx);

/// Function type for a route handler
typedef FutureOr<Response<RespType>> RouteHandlerFunc<RespType>(Context ctx);

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

  const Route(
      {this.path,
      this.methods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ],
      this.statusCode: 200,
      this.mimeType: kDefaultMimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.pathRegEx});
}

class Get extends RouteBase {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods = _methods;

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

  const Get(
      {this.path,
      this.statusCode: 200,
      this.mimeType: kDefaultMimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.pathRegEx});

  static const List<String> _methods = const <String>['GET'];
}

class Post extends RouteBase {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods = _methods;

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

  const Post(
      {this.path,
      this.statusCode: 200,
      this.mimeType: kDefaultMimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.pathRegEx});

  static const List<String> _methods = const <String>['POST'];
}

class Put extends RouteBase {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods = _methods;

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

  const Put(
      {this.path,
      this.statusCode: 200,
      this.mimeType: kDefaultMimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.pathRegEx});

  static const List<String> _methods = const <String>['PUT'];
}

class Delete extends RouteBase {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods = _methods;

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

  const Delete(
      {this.path,
      this.statusCode: 200,
      this.mimeType: kDefaultMimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.pathRegEx});

  static const List<String> _methods = const <String>['DELETE'];
}
