// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.websocket;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Ws('/ws')];

  final ExampleApi _internal;

  factory JaguarExampleApi() {
    final instance = new ExampleApi();
    return new JaguarExampleApi.from(instance);
  }
  JaguarExampleApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for websocket
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      try {
        WebSocket ws = await request.upgradeToWebSocket;
        await _internal.websocket(
          ws,
        );
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
