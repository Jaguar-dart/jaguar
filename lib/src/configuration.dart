library jaguar.src.configuration;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'jaguar.dart';

// TODO(kleak): add doc
class Configuration {
  final String address;
  final int port;
  final SecurityContext context;
  final bool multiThread;
  List<dynamic> apis;

  Configuration(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.context: null}) {
    apis = <dynamic>[];
  }

  void addApi(dynamic apiClass) {
    apis.add(apiClass);
  }
}

Future<Null> serve(Configuration configuration) async {
  String url =
      "${configuration.context == null ? 'http': 'https'}://${configuration.address}:${configuration.port}/";
  print("Start your server on $url");
  if (configuration.multiThread) {
    for (int i = 0; i < Platform.numberOfProcessors - 1; i++) {
      await Isolate.spawn(_serve, configuration);
    }
  }
  await _serve(configuration);
}

Future<Null> _serve(Configuration configuration) async {
  Jaguar j = new Jaguar(configuration);
  await j.serve();
}
