part of jaguar.src.serve;

abstract class RequestHandler {
  Future<Response> handleRequest(Request request, {String prefix});
}

class Jaguar {
  final Configuration configuration;

  Jaguar(this.configuration);

  Future<Null> serve() async {
    configuration.log.severe("Running on ${configuration.baseUrl}");
    await _serve();
  }

  Future handleRequest(HttpRequest request) async {
    final jaguarRequest = new Request(request);
    configuration.log
        .info("Req => Method: ${request.method} Url: ${request.uri}");
    try {
      Response response;
      for (RequestHandler requestHandler in configuration.apis) {
        response = await requestHandler.handleRequest(jaguarRequest);
        if (response is Response) {
          break;
        }
      }
      if (response is Response) {
        await response.writeResponse(request.response);
      } else {
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
