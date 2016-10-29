library jaguar.src.annotations;

///An annotation to define a route
class Route {
  final String path;

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
      ], this.statusCode: 200, this.headers});

  bool match(List<String> args, String requestPath, String method) {
    if (!methods.contains(method)) {
      return false;
    }

    RegExp regExp = new RegExp("^${path}\$");
    Iterable<Match> matchs = regExp.allMatches(requestPath);
    if (matchs.isEmpty) return false;
    matchs.forEach((Match match) {
      for (int i = 1; i <= match.groupCount; i++) {
        args.add(match.group(i));
      }
    });

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
