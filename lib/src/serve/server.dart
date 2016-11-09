part of jaguar.src.serve;

abstract class RequestHandler {
  Future requestHandler(HttpRequest request);
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
    _log.severe("Running on ${configuration.baseUrl}");
    await _serve();
  }

  Future<Null> handleRequest(HttpRequest request) async {
    _logRequest.info("Method: ${request.method} Url: ${request.uri}");
    try {
      for (int i = 0; i < configuration.apis.length; i++) {
        var apiClass = configuration.apis[i];
        bool result = await apiClass.requestHandler(request);
        if (result) break;
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
