library jaguar.generator.api_class;

class Parameter {
  final String type;
  final String name;
  final String value;
  final bool isOptional;

  const Parameter({this.type, this.name, this.value, this.isOptional});

  String toString() => "$type $name $value $isOptional";
}
