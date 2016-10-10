library jaguar.generator.route.route_information_generator;

import '../pre_processor/pre_processor.dart';
import 'route_information_processor.dart';
import '../post_processor/post_processor.dart';

class RouteInformationsGenerator {
  List<PreProcessor> preProcessors;
  RouteInformationsProcessor routeProcessor;
  List<PostProcessor> postProcessor;

  RouteInformationsGenerator(
      this.preProcessors, this.routeProcessor, this.postProcessor);

  String toString() {
    return "${routeProcessor.path} ${routeProcessor.parameters}";
  }
}
