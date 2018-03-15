part of jaguar.generator.parser.route;

class ParsedGroup {
  final ant.IncludeApi group;

  final DartType type;

  final String name;

  ParsedGroup(this.group, this.type, this.name);

  /// Returns the associated Group info if the field has Group annotation
  static ParsedGroup detectGroup(FieldElement element) {
    List<ant.IncludeApi> groups = element.metadata
        .map(_mkIncludeApi)
        .where((dynamic instance) => instance is ant.IncludeApi)
        .toList();

    if (groups.length == 0) {
      return null;
    }

    if (groups.length != 1) {
      StringBuffer sb = new StringBuffer();

      sb.write('${element.name} has more than one Group annotations.');
      throw new GeneratorException('', 0, sb.toString());
    }

    final DartType type = element.type;
    return new ParsedGroup(groups.first, type, element.name);
  }
}

ant.IncludeApi _mkIncludeApi(ElementAnnotation annot) {
  final DartObject v = annot.computeConstantValue();
  if (!isIncludeApi.isExactlyType(v.type)) return null;

  return new ant.IncludeApi(path: v.getField('path').toStringValue());
}
