import 'package:build/build.dart';

import 'package:jaguar/generator/phase/import.dart';

PhaseGroup getPhaseGroup() {
  return new PhaseGroup()
    ..addPhase(apisPhase('jaguar', ['test/test_files/api_test_example.dart']));
}

main() async {
  build(getPhaseGroup(), deleteFilesByDefault: true);
}
