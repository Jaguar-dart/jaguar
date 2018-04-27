part of jaguar.generator.parser.route;

class ParsedExceptionHandler {
  final ElementAnnotation _handler;

  String get handlerName => _handler.computeConstantValue().type.name;

  ParsedExceptionHandler(this._handler) {}

  String get instantiationString => _handler.toSource().substring(1);

  static ParsedExceptionHandler detectException(ElementAnnotation element) {
    if (element.constantValue.type.element is! ClassElement) {
      return null;
    }

    final ClassElement clazz = element.constantValue.type.element;

    final List<InterfaceType> interfaces = clazz.allSupertypes;

    InterfaceType interface;

    for (InterfaceType i in interfaces) {
      if (!isExceptionHandler.isExactlyType(i)) continue;
      interface = i;
      break;
    }

    if (interface == null) return null;

    return new ParsedExceptionHandler(element);
  }

  static List<ParsedExceptionHandler> detectAllExceptions(Element element) {
    return element.metadata
        .map(detectException)
        .where((value) => value is ParsedExceptionHandler)
        .toList();
  }
}
