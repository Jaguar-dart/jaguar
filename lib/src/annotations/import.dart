library jaguar.src.annotations;

///An annotation to define a route
class Route {
  final String path;

  final List<String> methods;

  const Route(this.path,
      {this.methods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ]});

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
  final String name;
  final String version;

  const Api({this.name: '', this.version: ''});

  String get url {
    String prefix = "";
    if (name != null && name.isNotEmpty) {
      prefix += "${name}";
    }

    if (version != null && version.isNotEmpty) {
      prefix += "${version}";
    }

    return prefix;
  }
}

///An annotation to define an API group in API class
class Group {
  ///Path prefix to the group
  final String name;

  const Group({this.name});
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

class InterceptDual {
  final Type returns;

  const InterceptDual({this.returns});
}

class Input {
  final Type resultFrom;

  const Input(this.resultFrom);
}
