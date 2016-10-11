library jaguar.generator.route_informations_generator;

import '../pre_interceptors/pre_interceptor.dart';
import 'route_informations_processor.dart';
import '../post_interceptors/post_interceptor.dart';

class RouteInformationsGenerator {
  List<PreInterceptor> preProcessors;
  RouteInformationsInterceptor routeProcessor;
  List<PostInterceptor> postProcessor;

  RouteInformationsGenerator(
      this.preProcessors, this.routeProcessor, this.postProcessor);

  String toString() {
    return "${routeProcessor.path} ${routeProcessor.parameters}";
  }
}
