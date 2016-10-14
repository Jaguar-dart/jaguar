library jaguar.generator.route_informations_generator;

import '../pre_interceptors/pre_interceptor.dart';
import 'interceptor.dart';
import '../post_interceptors/post_interceptor.dart';

class RouteInformationsGenerator {
  List<PreInterceptor> preInterceptors;
  RouteInformationsInterceptor routeInterceptor;
  List<PostInterceptor> postInterceptor;

  RouteInformationsGenerator(
      this.preInterceptors, this.routeInterceptor, this.postInterceptor);

  String toString() {
    return "${routeInterceptor.path} ${routeInterceptor.parameters} ${routeInterceptor.namedParameters}";
  }
}
