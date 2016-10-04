library jaguar.generator.processor;

abstract class Processor {
  const Processor();
}

class Route extends Processor {
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

class Api extends Processor {
  final String name;
  final String version;

  const Api({this.name: '', this.version: ''});
}

class Group extends Processor {
  final String name;

  const Group({this.name});
}
