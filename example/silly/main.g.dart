// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.example.silly;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class MyGroup
// **************************************************************************

abstract class _$JaguarMyGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get('/')];

  String get();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/myGroup';
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = get();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class MySecondGroup
// **************************************************************************

abstract class _$JaguarMySecondGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get('/')];

  String get();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/mySecondGroup';
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = get();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route('/ping', methods: const <String>['GET']),
    const Put('/pong',
        statusCode: 201, headers: const {"pong-header": "silly-pong"}),
    const Route('/echo/pathparam/:message', methods: const <String>['POST']),
    const Route('/echo/queryparam', methods: const <String>['POST']),
    const Ws('/ws')
  ];

  MyGroup get myGroup;
  MySecondGroup get mySecondGroup;

  String ping();

  String pong();

  String echoPathParam(String message);

  String echoQueryParam({String message});

  Future<dynamic> websocket(WebSocket ws);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = ping();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = pong();
      request.response.statusCode = 201;
      request.response.headers.add("pong-header", "silly-pong");
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
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

    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = echoQueryParam(
        message: (queryParams.getField('message')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      WebSocket ws = await WebSocketTransformer.upgrade(request);
      await websocket(
        ws,
      );
      return true;
    }

    if (await myGroup.handleRequest(request)) {
      return true;
    }

    if (await mySecondGroup.handleRequest(request)) {
      return true;
    }

    return false;
  }
}
