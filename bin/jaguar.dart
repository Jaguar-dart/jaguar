import 'package:build/build.dart';

import 'package:jaguar/generator/phases.dart';

main(List<String> args) {
  if (args.length > 0) {
    if (args[0] == 'watch') {
      watch(phaseGroup(), deleteFilesByDefault: true);
    } else if (args[0] == 'build') {
      build(phaseGroup(), deleteFilesByDefault: true);
    }
  }
}
