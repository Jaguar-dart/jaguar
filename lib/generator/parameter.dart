library jaguar.generator.api_class;

class Parameter {
  final String stringType;
  final Type type;
  final String name;
  final String value;
  final bool isOptional;

  const Parameter(
      {this.stringType,
      this.name,
      this.value,
      this.isOptional: false,
      this.type: null});

  String toString() => "$stringType $name $value $isOptional";
}
