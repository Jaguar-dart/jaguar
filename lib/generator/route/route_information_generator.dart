library jaguar.generator.route.route_information_generator;

import '../pre_interceptors/pre_interceptor.dart';
import 'route_information_processor.dart';
import '../post_interceptors/post_interceptor.dart';

class RouteInformationsGenerator {
  List<PreInterceptor> preProcessors;
  RouteInformationsProcessor routeProcessor;
  List<PostInterceptor> postProcessor;

  RouteInformationsGenerator(
      this.preProcessors, this.routeProcessor, this.postProcessor);

  String toString() {
    return "${routeProcessor.path} ${routeProcessor.parameters}";
  }
}
