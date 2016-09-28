import 'dart:io';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';
import 'package:jaguar/generator/phases.dart';

String getBin() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['bin'];
}

void launchWatch() {
  Process process;
  watch(phaseGroup(), deleteFilesByDefault: true)
      .listen((BuildResult result) async {
    if (result.status == BuildStatus.success) {
      if (process != null) {
        print("kill old server");
        Process.killPid(process.pid);
      }
      print("launch new server");
      String bin = getBin() ?? 'bin/server.dart';
      process = await Process.start('dart', [bin]);
    }
  });
}

main(List<String> args) {
  if (args.length > 0) {
    if (args[0] == 'watch') {
      launchWatch();
    } else if (args[0] == 'build') {
      build(phaseGroup(), deleteFilesByDefault: true);
    }
  }
}
