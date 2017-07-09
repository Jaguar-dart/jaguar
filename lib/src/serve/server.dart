part of jaguar.src.serve;

/// Base class for Request handlers
abstract class RequestHandler {
  Future<Response> handleRequest(Context ctx, {String prefix});
}

/// The Jaguar server
///
/// It servers the provided APIs on the given `address` and `port`
/// `securityContext``is used to add HTTPS support
class Jaguar {
  /// Address on which the API is serviced
  final String address;

  /// Port on which the API is serviced
  final int port;

  /// Security context
  final SecurityContext securityContext;

  /// Should the port be servicable from multiple isolates
  final bool multiThread;

  /// [RequestHandler]s
  final List<RequestHandler> _apis = <RequestHandler>[];

  /// Should the response be auto-compressed
  final bool autoCompress;

  /// Base path
  final String basePath;

  HttpServer _server;

  final ErrorWriter errorWriter;

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
      this.basePath: '',
      this.errorWriter: const HtmlErrorWriter()});

  /// Adds given API [api] to list of API that will be served
  void addApi(RequestHandler api) {
    _apis.add(api);
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
    log.info("Req => Method: ${request.method} Url: ${request.uri}");
    final ctx = new Context(new Request(request, log));
    ctx.addInterceptors(_interceptorCreators);
    try {
      Response response;
      for (RequestHandler requestHandler in _apis) {
        response = await requestHandler.handleRequest(ctx, prefix: basePath);
        if (response is Response) {
          break;
        }
      }
      if (response is Response) {
        await response.writeResponse(request.response);
      } else {
        throw new NotFoundError("The path ${request.uri.path} is not found!");
      }
    } catch (e, stack) {
      log.severe(
          "ReqErr => Method: ${request.method} Url: ${request.uri} E: $e Stack: $stack");
      final Response resp =
          errorWriter.writeError(request.uri.toString(), e, stack, 500);
      await resp.writeResponse(request.response);
    } finally {
      await request.response.close();
    }
  }

  final _interceptorCreators = <InterceptorCreator>[];

  UnmodifiableListView<InterceptorCreator> get interceptorCreators =>
      new UnmodifiableListView<InterceptorCreator>(_interceptorCreators);
}
