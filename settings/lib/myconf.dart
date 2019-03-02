import 'dart:io';
import 'package:args/args.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:yaml/yaml.dart';

Future<T> parseConfigArgs<T>(List<String> args, Serializer<T> serializer,
    {T defaultConf, bool mustLoad = false}) async {
  // Get the config file name from command line argument
  final parser = ArgParser();
  parser.addOption('config', abbr: 'c', help: 'Config file');
  ArgResults results = parser.parse(args);
  String configFile = results['config'];
  if (configFile == null) {
    if (mustLoad) {
      throw Exception("Config file not specified in command line argument.");
    }
    return defaultConf;
  }

  return parseConfigFile(configFile, serializer);
}

Future<T> parseConfigFile<T>(
    /* String | File */ file, Serializer<T> serializer) async {
  File yaml;
  if (file is String) {
    yaml = File(file);
  } else if (file is File) {
    yaml = file;
  } else {
    throw ArgumentError.value(file, 'file', 'Should be file name or file');
  }
  if (!await yaml.exists()) {
    throw Exception("Config file ${yaml.path} not found!");
  }
  Map<String, dynamic> settings;
  try {
    settings =
        (loadYaml(await yaml.readAsString()) as Map).cast<String, dynamic>();
  } catch (e) {
    throw Exception("Config file is not a valid yaml file: $e");
  }
  return serializer.fromMap(settings);
}
