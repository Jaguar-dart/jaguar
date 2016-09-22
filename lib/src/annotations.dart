library source_gen_experimentation.annotations;

class Api {
  final String name;
  final String version;

  const Api({this.name, this.version});

  String toString() => "$name $version";
}

class Route {
  final String path;

  final List<String> methods;

  const Route({this.path: '', this.methods});
}

class Group {
  final String path;

  const Group({this.path: ''});
}
