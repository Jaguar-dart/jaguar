import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar/generator/pre_processor/pre_processor_function_annotation_generator.dart';
import 'package:jaguar/generator/post_processor/post_processor_function_annotation_generator.dart';

Phase postProcessorPhase() {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const PostProcessorFunctionAnnotationGenerator(),
        ]),
        new InputSet('jaguar', [
          'lib/generator/post_processor/post_processor_function.dart',
        ]));
}

Phase preProcessorPhase() {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const PreProcessorFunctionAnnotationGenerator(),
        ]),
        new InputSet('jaguar', [
          'lib/generator/pre_processor/pre_processor_function.dart',
        ]));
}

PhaseGroup getPhaseGroup() {
  return new PhaseGroup()
    ..addPhase(postProcessorPhase())
    ..addPhase(preProcessorPhase());
}

main() async {
  build(getPhaseGroup(), deleteFilesByDefault: true);
}
