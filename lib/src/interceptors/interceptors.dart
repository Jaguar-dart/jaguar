library jaguar.src.interceptors;

abstract class Interceptor {
  const Interceptor();
}

class Route extends Interceptor {
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

class Api extends Interceptor {
  final String name;
  final String version;

  const Api({this.name: '', this.version: ''});
}

class Group extends Interceptor {
  final String name;

  const Group({this.name});
}
