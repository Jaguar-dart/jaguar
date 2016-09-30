import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar/generator/pre_processor/pre_processor_function_annotation_generator.dart';
import 'package:jaguar/generator/post_processor/post_processor_function_annotation_generator.dart';

PhaseGroup getPhaseGroup() {
  return new PhaseGroup.singleAction(
      new GeneratorBuilder(const [
        const PreProcessorFunctionAnnotationGenerator(),
        const PostProcessorFunctionAnnotationGenerator()
      ]),
      new InputSet('jaguar', [
        'lib/generator/pre_processor/pre_processor_function.dart',
        'lib/generator/post_processor/post_processor_function.dart'
      ]));
}

main() {
  build(getPhaseGroup(), deleteFilesByDefault: true);
}
