part of jaguar.src.serve;

abstract class RequestHandler {
  Future handleRequest(HttpRequest request, {String prefix});
}

class Jaguar {
  Configuration configuration;

  Jaguar(this.configuration);

  Future<Null> serve() async {
    configuration.log.severe("Running on ${configuration.baseUrl}");
    await _serve();
  }

  Future<Null> handleRequest(HttpRequest request) async {
    configuration.log
        .info("Req => Method: ${request.method} Url: ${request.uri}");
    try {
      bool throwNotFound = true;
      for (RequestHandler requestHandler in configuration.apis) {
        bool result = await requestHandler.handleRequest(request);
        if (result) {
          throwNotFound = false;
          break;
        }
      }
      if (throwNotFound) {
        throw new NotFoundError("This path ${request.uri.path} is not found");
      }
    } catch (e, stack) {
      configuration.log.severe(
          "ReqErr => Method: ${request.method} Url: ${request.uri} E: $e Stack: $stack");
      writeErrorPage(request.response, request.uri.toString(), e, stack, 500);
    } finally {
      await request.response.close();
    }
  }

  Future<Null> _serve([dynamic message]) async {
    HttpServer server;
    if (configuration.securityContext != null) {
      server = await HttpServer.bindSecure(configuration.address,
          configuration.port, configuration.securityContext);
    } else {
      server = await HttpServer.bind(configuration.address, configuration.port,
          shared: configuration.multiThread);
    }
    server.listen((HttpRequest request) => handleRequest(request));
  }
}
