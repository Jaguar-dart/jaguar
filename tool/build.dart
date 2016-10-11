import 'package:build/build.dart';

import 'package:jaguar/generator/phases.dart';

PhaseGroup getPhaseGroup() {
  return new PhaseGroup()
    ..addPhase(postProcessorPhase(
      'jaguar',
      ['lib/src/interceptors/post/function.dart'],
    ))
    ..addPhase(preProcessorPhase('jaguar', [
      'lib/src/interceptors/pre/function.dart',
    ]));
}

main() async {
  build(getPhaseGroup(), deleteFilesByDefault: true);
}
