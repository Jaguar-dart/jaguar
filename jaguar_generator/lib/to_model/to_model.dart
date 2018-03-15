library jaguar_generator.toModels;

import 'package:jaguar_generator/parser/parser.dart';
import 'package:jaguar_generator/models/models.dart';

class ToModelUpper {
  ParsedUpper upper;

  final Upper _ret = new Upper();

  ToModelUpper(this.upper) {}

  Upper toModel() => _ret;

  void perform() {
    _ret.baseName = upper.name;
    _ret.prefix = upper.path;

    for (ParsedRoute route in upper.routes) {
      Route newRoute = new Route();
      newRoute.instantiation = 'const ' + route.instantiationString;

      newRoute.interceptors = []
        ..addAll(upper.interceptors)
        ..addAll(route.interceptors);

      _ret.routes.add(newRoute);

      {
        RouteMethod method = new RouteMethod();

        method.name = route.method.name;
        method.returnType = route.method.returnType
            .flattenFutures(route.method.context.typeSystem)
            .displayName;
        method.returnsVoid = route.method.returnType.isVoid;
        method.returnsResponse = route.returnsResponse;
        if (!route.jaguarResponseType.isVoid) {
          method.jaguarResponseType = route.jaguarResponseType.name;
        } else {
          method.jaguarResponseType = 'dynamic';
        }
        method.isAsync = route.method.returnType.isDartAsyncFuture;
        newRoute.method = method;
      }

      //Exceptions
      {
        List<ExceptionHandler> handlers = <ExceptionHandler>[];

        final func = (ParsedExceptionHandler except) => new ExceptionHandler(
            except.handlerName, except.instantiationString);

        upper.exceptions.map(func).forEach(handlers.add);
        route.exceptions.map(func).forEach(handlers.add);
        newRoute.exceptions = handlers;
      }
    }

    for (ParsedGroup group in upper.groups) {
      Group newGroup = new Group();

      newGroup.name = group.name;
      newGroup.path = group.group.path;
      newGroup.type = group.type.displayName;

      _ret.groups.add(newGroup);
    }

    for (Route r in _ret.routes) {
      for (InterceptorCreatorFunc i in r.interceptors) {
        if (i.isMember) _ret.interceptorMethods[i.name] = true;
      }
    }
  }
}
