part of jaguar.src.serve;

abstract class RequestHandler {
  Future handleRequest(HttpRequest request, {String prefix});
}

//  TODO(kleak): add doc
class Jaguar {
  Configuration configuration;

  Jaguar(this.configuration) {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((LogRecord rec) {
      String dateStr = _dateFormatter.format(rec.time);
      print('[@$dateStr ${rec.loggerName}]: ${rec.message}');
    });
  }

  final DateFormat _dateFormatter = new DateFormat('MM-dd H:m');

  final Logger _log = new Logger('J');

  final Logger _logRequest = new Logger('J.Req');

  Future<Null> serve() async {
    await configuration.instanciateSettings();

    _log.severe("Running on ${configuration.baseUrl}");
    await _serve();
  }

  Future<Null> handleRequest(HttpRequest request) async {
    _logRequest.info("Method: ${request.method} Url: ${request.uri}");
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
      _logRequest.severe(
          "Method: ${request.method} Url: ${request.uri} E: $e Stack: $stack");
      writeErrorPage(request.response, request.uri.toString(), e, stack, 500);
    } finally {
      await request.response.close();
    }
  }

  Future<Null> _serve([dynamic message]) async {
    bool share = configuration.multiThread;
    HttpServer server;
    if (configuration.securityContext != null) {
      server = await HttpServer.bindSecure(configuration.address,
          configuration.port, configuration.securityContext);
    } else {
      server = await HttpServer.bind(configuration.address, configuration.port,
          shared: share);
    }
    server.listen((HttpRequest request) => handleRequest(request));
  }
}
