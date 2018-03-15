part of jaguar.generator.parser.route;

class ParsedRoute {
  final ParsedUpper upper;

  final MethodElement method;

  final ElementAnnotation routeAnnot;

  final List<InterceptorCreatorFunc> interceptors;

  final List<ParsedExceptionHandler> exceptions;

  String get instantiationString => routeAnnot.toSource().substring(1);

  bool get returnsResponse =>
      !method.returnType.flattenFutures(method.context.typeSystem).isVoid &&
      isResponse.isAssignableFromType(
          method.returnType.flattenFutures(method.context.typeSystem));

  DartType get jaguarResponseType {
    if (!returnsResponse) {
      return method.returnType.flattenFutures(method.context.typeSystem);
    }

    return (method.returnType.flattenFutures(method.context.typeSystem)
            as ParameterizedType)
        .typeArguments
        .first;
  }

  ParsedRoute(this.upper, this.method, this.routeAnnot, this.interceptors,
      this.exceptions);
}

class _ParsedRouteBuilder {
  final ParsedUpper upper;

  final MethodElement method;

  ParsedRoute _route;

  ParsedRoute get route => _route;

  _ParsedRouteBuilder(this.upper, this.method) {
    List<ElementAnnotation> annots = method.metadata
        .where((annot) =>
            isRouteBase.isAssignableFromType(annot.computeConstantValue().type))
        .toList();

    if (annots.length == 0) {
      return;
    }

    if (annots.length != 1) {
      final except = new RouteException(
          'Route method has more than one route annotations!');
      except.upper = upper.name;
      except.route = method.name;
      throw except;
    }

    final List<InterceptorCreatorFunc> interceptors =
        detectWrappers(upper.upper, method);

    final List<ParsedExceptionHandler> exceptions = [];
    ParsedExceptionHandler.detectAllExceptions(method).forEach(exceptions.add);

    _route =
        new ParsedRoute(upper, method, annots.first, interceptors, exceptions);
  }
}
