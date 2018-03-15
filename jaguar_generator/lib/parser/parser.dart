library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/src/dart/constant/value.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar_generator/common/exceptions/exceptions.dart';

import '../common/constants.dart';

import '../models/models.dart';

part 'exception.dart';
part 'group.dart';
part 'route.dart';
part 'interceptor/wrapper_creator.dart';

class ParsedUpper {
  final ClassElement upper;

  final String path;

  String get name => upper.name;

  final List<ParsedRoute> routes = <ParsedRoute>[];

  final List<InterceptorCreatorFunc> interceptors = <InterceptorCreatorFunc>[];

  final List<ParsedGroup> groups = <ParsedGroup>[];

  final List<ParsedExceptionHandler> exceptions = <ParsedExceptionHandler>[];

  ParsedUpper(this.upper, this.path);

  void parse() {
    _collectInterceptor();

    _collectRoutes();

    _collectGroups();

    ParsedExceptionHandler.detectAllExceptions(upper).forEach(exceptions.add);
  }

  void _collectInterceptor() {
    interceptors.addAll(detectWrappers(upper, upper));
  }

  void _collectRoutes() {
    for (MethodElement method in upper.methods) {
      ParsedRoute route;

      try {
        route = new _ParsedRouteBuilder(this, method).route;
      } on ExceptionOnRoute catch (e) {
        e.route = method.name;
        e.upper = upper.name;
        rethrow;
      }

      if (route == null) {
        continue;
      }

      routes.add(route);
    }
  }

  void _collectGroups() {
    for (FieldElement field in upper.fields) {
      ParsedGroup group = ParsedGroup.detectGroup(field);

      if (group == null) {
        continue;
      }

      groups.add(group);
    }
  }
}

class GeneratorException {
  final String filename;

  final int line;

  final String message;

  GeneratorException(this.filename, this.line, this.message);

  String toString() => message;
}

class InputInterceptorException {
  final String message;

  String upper;

  String route;

  String interceptor;

  String input;

  String param;

  InputInterceptorException(this.message);

  String toString() {
    StringBuffer sb = new StringBuffer();

    sb.writeln('Message: $message');
    sb.writeln('RequestHandler: $upper');
    sb.writeln('Route: $route');
    if (interceptor is String) {
      sb.writeln('Interceptor: $interceptor');
    }
    if (input is String) {
      sb.writeln('Input: $input');
    }
    if (param is String) {
      sb.writeln('Param: $param');
    }

    return sb.toString();
  }
}
