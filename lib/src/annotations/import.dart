library jaguar.src.annotations;

///An annotation to define a route
class Route {
  final String path;
  final List<String> methods;

  const Route(
      {this.path: '',
      this.methods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ]});
}

///An annotation to define an API class
class Api {
  final String name;
  final String version;

  const Api({this.name: '', this.version: ''});
}

///An annotation to define an API group in API class
class Group {
  ///Path prefix to the group
  final String name;

  const Group({this.name});
}

///An annotation to add a function as interceptor to a route
class InterceptFunction {
  ///Function that contains the implementation of the interceptor
  final Function function;

  const InterceptFunction(this.function);
}

class Input {
  final Type resultFrom;

  const Input(this.resultFrom);
}