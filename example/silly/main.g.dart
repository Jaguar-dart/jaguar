// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.example.silly;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<Route> _routes = <Route>[
    new Route(r"/api/ping", methods: ["GET"]),
    new Route(r"/api/pong", methods: ["POST"]),
  ];

  String ping();

  String pong();

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;

    match = _routes[0].match(args, request.uri.path, request.method);
    if (match) {
      String rResponse = ping();
      request.response.statusCode = 200;
      request.response
        ..write(rResponse.toString())
        ..close();
      return true;
    }

    match = _routes[1].match(args, request.uri.path, request.method);
    if (match) {
      String rResponse = pong();
      request.response.statusCode = 201;
      request.response.headers.add("pong-header", "silly-pong");
      request.response
        ..write(rResponse.toString())
        ..close();
      return true;
    }

    return false;
  }
}
