part of jaguar.src.serve;

/// Base class for Request handlers
abstract class RequestHandler {
  Future<Response> handleRequest(Request request, {String prefix});
}

/// The Jaguar server
///
/// It servers the provided APIs on the given `address` and `port`
/// `securityContext``is used to add HTTPS support
class Jaguar {
  final String address;
  final int port;
  final SecurityContext securityContext;
  final bool multiThread;
  final List<RequestHandler> apis = <RequestHandler>[];
  final bool autoCompress;
  final String basePath;

  HttpServer _server;

  /// Logger
  final Logger log = new Logger('J');

  /// Returns protocol string
  String get protocolStr => securityContext == null ? 'http' : 'https';

  /// Base path
  String get resourceName => "$protocolStr://$address:$port/";

  Jaguar(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.securityContext: null,
      this.autoCompress: false,
      this.basePath: ''});

  /// Adds given API [api] to list of API that will be served
  void addApi(RequestHandler api) {
    apis.add(api);
  }

  /// Starts serving the provided APIs
  Future<Null> serve() async {
    if (_server != null) throw new Exception('Already serving!');
    log.severe("Running on $resourceName");
    if (securityContext != null) {
      _server = await HttpServer.bindSecure(address, port, securityContext);
    } else {
      _server = await HttpServer.bind(address, port, shared: multiThread);
    }
    _server.autoCompress = autoCompress;
    _server.listen((HttpRequest request) => _handleRequest(request));
  }

  /// Closes the server
  Future<Null> close() async {
    await _server.close(force: true);
    _server = null;
  }

  Future _handleRequest(HttpRequest request) async {
    final jaguarRequest = new Request(request, log);
    log.info("Req => Method: ${request.method} Url: ${request.uri}");
    try {
      Response response;
      for (RequestHandler requestHandler in apis) {
        response =
            await requestHandler.handleRequest(jaguarRequest, prefix: basePath);
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
      log.severe(
          "ReqErr => Method: ${request.method} Url: ${request.uri} E: $e Stack: $stack");
      writeErrorPage(request.response, request.uri.toString(), e, stack, 500);
    } finally {
      await request.response.close();
    }
  }
}
