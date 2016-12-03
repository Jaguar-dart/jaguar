part of jaguar.src.annotations;

abstract class RouteBase {
  const RouteBase();

  String get path;

  List<String> get methods;

  int get statusCode;

  Map<String, String> get headers;

  Map<String, String> get pathRegEx;

  String prefixedPath(String prefix) => '' + (prefix ?? '') + (path ?? '');

  bool match(String requestPath, String method, String prefix,
      Map<String, dynamic> params) {
    params.clear();

    if (!methods.contains(method)) {
      return false;
    }

    List<String> rqSegs = requestPath.split('/');

    List<String> segs = prefixedPath(prefix).split('/');

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
  final String path;

  final List<String> methods;

  final int statusCode;

  final Map<String, String> headers;

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
      this.headers,
      this.pathRegEx});
}

class Get extends RouteBase {
  final String path;

  final List<String> methods = _methods;

  final int statusCode;

  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  const Get({
    this.path,
    this.statusCode: 200,
    this.headers,
    this.pathRegEx,
  });

  static const List<String> _methods = const <String>['GET'];
}

class Post extends RouteBase {
  final String path;

  final List<String> methods = _methods;

  final int statusCode;

  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  const Post({
    this.path,
    this.statusCode: 200,
    this.headers,
    this.pathRegEx,
  });

  static const List<String> _methods = const <String>['POST'];
}

class Put extends RouteBase {
  final String path;

  final List<String> methods = _methods;

  final int statusCode;

  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  const Put({
    this.path,
    this.statusCode: 200,
    this.headers,
    this.pathRegEx,
  });

  static const List<String> _methods = const <String>['PUT'];
}

class Delete extends RouteBase {
  final String path;

  final List<String> methods = _methods;

  final int statusCode;

  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  const Delete({
    this.path,
    this.statusCode: 200,
    this.headers,
    this.pathRegEx,
  });

  static const List<String> _methods = const <String>['DELETE'];
}
