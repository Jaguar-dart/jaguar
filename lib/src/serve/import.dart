library jaguar.src.serve;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:intl/intl.dart';

import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';

import 'package:jaguar/src/serve/error_writer/import.dart';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

part 'config.dart';
part 'server.dart';
part 'settings.dart';

//Sugar to create a Jaguar server instance and serve it
Future _serveInstance(Configuration configuration) async {
  Jaguar j = new Jaguar(configuration);
  await j.serve();
}

///Serves the API with given configuration [configuration]
Future<Null> serve(Configuration configuration) async {
  if (configuration.multiThread) {
    for (int i = 0; i < Platform.numberOfProcessors - 1; i++) {
      await Isolate.spawn(_serveInstance, configuration);
    }
  }

  await _serveInstance(configuration);
}
