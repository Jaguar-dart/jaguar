library source_gen_experimentation.generators.route;

import 'package:analyzer/dart/element/element.dart';

class RouteInformationsGenerator {
  String path;
  List<String> methods;
  String signature;
  String returnType;
  List<ParameterElement> parameters;

  RouteInformationsGenerator(this.path, this.methods, this.signature,
      this.returnType, this.parameters);

  String toString() => "$path $methods";
}

class RouteInformations {
  String path;
  List<String> methods;
  Function function;

  RouteInformations(this.path, this.methods, this.function);

  bool matchWithRequestPathAndMethod(
      List<String> args, String requestPath, String method) {
    if (!methods.contains(method)) return false;
    RegExp regExp = new RegExp("^${path}\$");
    Iterable<Match> matchs = regExp.allMatches(requestPath);
    if (matchs.isEmpty) return false;
    matchs.forEach((Match match) {
      for (int i = 1; i <= match.groupCount; i++) {
        args.add(match.group(i));
      }
    });
    return true;
  }

  String toString() => "$path $methods";
}
