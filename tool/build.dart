import 'package:build/build.dart';

import 'package:jaguar/generator/phases.dart';

PhaseGroup getPhaseGroup() {
  return new PhaseGroup()
    ..addPhase(postInterceptorPhase(
      'jaguar',
      ['lib/src/interceptors/post/function.dart'],
    ))
    ..addPhase(preInterceptorPhase('jaguar', [
      'lib/src/interceptors/pre/function.dart',
    ]))
    ..addPhase(apisPhase('jaguar', ['test/test_files/api_test_example.dart']));
}

main() async {
  build(getPhaseGroup(), deleteFilesByDefault: true);
}
