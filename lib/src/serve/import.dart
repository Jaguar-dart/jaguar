library jaguar.src.serve;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:jaguar/src/error.dart';

part 'config.dart';
part 'server.dart';

///Serves the API with given configuration [configuration]
Future<Null> serve(Configuration configuration) async {
  print("Running on ${configuration.baseUrl}");

  //Sugar to create a Jaguar server instance and serve it
  Function server = (Configuration configuration) async {
    Jaguar j = new Jaguar(configuration);
    await j.serve();
  };

  if (configuration.multiThread) {
    for (int i = 0; i < Platform.numberOfProcessors - 1; i++) {
      await Isolate.spawn(server, configuration);
    }
  }

  await server(configuration);
}
