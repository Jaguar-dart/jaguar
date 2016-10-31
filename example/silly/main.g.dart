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
    new Route(r"/api/echo/pathparam/:message", methods: ["POST"]),
    new Route(r"/api/echo/queryparam", methods: ["POST"]),
  ];

  String ping();

  String pong();

  String echoPathParam(String message);

  String echoQueryParam(String message);

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams();
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);
    bool match = false;

    match = _routes[0].match(request.uri.path, request.method, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = ping();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[1].match(request.uri.path, request.method, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = pong();
      request.response.statusCode = 201;
      request.response.headers.add("pong-header", "silly-pong");
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[2].match(request.uri.path, request.method, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = echoPathParam(
        (pathParams.getField('message')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[3].match(request.uri.path, request.method, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = echoQueryParam(
        (pathParams.getField('message')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}
