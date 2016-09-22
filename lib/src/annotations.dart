library source_gen_experimentation.annotations;

class ApiClass {
  final String name;
  final String version;

  const ApiClass({this.name, this.version});

  String toString() => "$name $version";
}

class ApiMethod {
  final String path;

  final List<String> methods;

  const ApiMethod({this.path: '', this.methods});
}

class ApiResource {
  final String path;

  const ApiResource({this.path: ''});
}
