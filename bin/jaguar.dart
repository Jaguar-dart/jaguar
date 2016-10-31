import 'dart:io';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';
import 'package:jaguar/generator/phase/import.dart';

String getBin() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['bin'] ?? 'bin/server.dart';
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
      String bin = getBin();
      process = await Process.start('dart', [bin]);
      process.stdout.transform(UTF8.decoder).listen(stdout.write);
      process.stderr.transform(UTF8.decoder).listen(stderr.write);
    }
  });
}

main(List<String> args) {
  if (args.length > 0) {
    if (args[0] == 'watch') {
      launchWatch();
    } else if (args[0] == 'build') {
      build(phaseGroup(), deleteFilesByDefault: true);
    } else {
      print("Invalid command!");
    }
  }
}
