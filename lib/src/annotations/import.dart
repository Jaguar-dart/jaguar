library jaguar.src.annotations;

///An annotation to define a route
class Route {
  final String path;

  final Map<String, String> pathRegEx;

  final List<String> methods;

  final int statusCode;

  final Map<String, String> headers;

  const Route(this.path,
      {this.methods: const <String>[
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

  bool match(String requestPath, String method, Map<String, dynamic> params) {
    params.clear();

    if (!methods.contains(method)) {
      return false;
    }

    List<String> rqSegs = requestPath.split('/');

    List<String> segs = path.split('/');

    return comparePathSegments(segs, rqSegs, params);
  }

  bool comparePathSegments(
      List<String> template, List<String> actual, Map<String, String> args) {
    if (template.length != actual.length) {
      return false;
    }

    for (int index = 0; index < template.length; index++) {
      if (template[index].isNotEmpty && template[index][0] == ':') {
        //TODO move this to generator side
        if (template[index].length < 2) {
          throw new Exception("Invalid URL parameter specification!");
        }

        final String argName = template[index].substring(1);

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

///An annotation to define an API class
class Api {
  final String path;

  const Api({this.path: ''});

  String get url {
    String prefix = "";
    if (path != null && path.isNotEmpty) {
      prefix += "${path}";
    }

    return prefix;
  }
}

///An annotation to define an API group in API class
class Group {
  ///Path prefix to the group
  final String path;

  const Group({this.path});
}

class DefineInterceptorFunc {
  const DefineInterceptorFunc();
}

///An annotation to add a function as interceptor to a route
class InterceptFunction {
  ///Function that contains the implementation of the interceptor
  final Function function;

  final bool isPost;

  const InterceptFunction(this.function, {this.isPost: false});
}

/// Defines a dual interceptor
class DefineInterceptDual {
  final bool writesResponse;

  const DefineInterceptDual({this.writesResponse: false});
}

/// Base class for dual interceptors
class InterceptorDual {
  final String id;

  const InterceptorDual({this.id});
}

/// Defines inputs to an interceptor
class Input {
  final Type resultFrom;

  final String id;

  const Input(this.resultFrom, {this.id});
}
