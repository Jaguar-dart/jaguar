library jaguar.generator.api_class;

class Parameter {
  final String typeAsString;
  final Type type;
  final String name;
  final String value;
  final bool isOptional;

  const Parameter(
      {this.typeAsString,
      this.name,
      this.value,
      this.isOptional: false,
      this.type: null});

  String toString() => "$typeAsString $name $value $isOptional";
}
