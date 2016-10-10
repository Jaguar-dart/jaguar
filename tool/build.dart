import 'package:build/build.dart';

import 'package:jaguar/generator/phases.dart';

PhaseGroup getPhaseGroup() {
  return new PhaseGroup()
    ..addPhase(postProcessorPhase(
      'jaguar',
      ['lib/generator/post_processor/post_processor_function.dart'],
    ))
    ..addPhase(preProcessorPhase('jaguar', [
      'lib/generator/pre_processor/pre_processor_function.dart',
    ]));
}

main() async {
  build(getPhaseGroup(), deleteFilesByDefault: true);
}
