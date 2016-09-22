import 'dart:async';
import 'dart:io';

import 'configuration.dart';
import 'error.dart';

//  TODO(kleak): add doc
class Jaguar {
  Configuration configuration;

  Jaguar(this.configuration);

  Future<Null> serve() async {
    await _serve();
  }

  Future<Null> handleRequest(HttpRequest request) async {
    try {
      for (int i = 0; i < configuration.apis.length; i++) {
        var apiClass = configuration.apis[i];
        var result = await apiClass.handleApiRequest(request);
        if (result != null) break;
      }
    } catch (e) {
      print(e);
    } finally {
      await request.response.close();
    }
  }

  Future<Null> _serve([dynamic message]) async {
    bool share = configuration.multiThread;
    HttpServer server;
    if (configuration.context != null) {
      server = await HttpServer.bindSecure(
          configuration.address, configuration.port, configuration.context);
    } else {
      server = await HttpServer.bind(configuration.address, configuration.port,
          shared: share);
    }
    server.listen((HttpRequest request) => handleRequest(request));
  }
}
