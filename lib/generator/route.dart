library jaguar.generators.route;

import 'processor.dart';
import 'pre_processor.dart';
import 'post_processor.dart';

class RouteInformationsGenerator {
  List<PreProcessor> preProcessor;
  RouteInformationsProcessor processor;
  List<PostProcessor> postProcessor;

  RouteInformationsGenerator(
      this.preProcessor, this.processor, this.postProcessor);
}

class RouteInformations {
  String path;
  List<String> methods;

  RouteInformations(this.path, this.methods);

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
}
