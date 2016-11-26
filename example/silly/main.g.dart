// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.example.silly;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class MyGroup
// **************************************************************************

abstract class _$JaguarMyGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get(path: '/')];

  String get();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/myGroup';
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = get();
      await rRouteResponse.writeResponse(request.response);
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
  static const List<RouteBase> routes = const <RouteBase>[const Get(path: '/')];

  String get();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/mySecondGroup';
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = get();
      await rRouteResponse.writeResponse(request.response);
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
    const Route(path: '/ping', methods: const <String>['GET']),
    const Put(path: '/pong',
        statusCode: 201, headers: const {"pong-header": "silly-pong"}),
    const Route(path: '/echo/pathparam/:message', methods: const <String>['POST']),
    const Route(path: '/echo/queryparam', methods: const <String>['POST']),
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
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = ping();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 201;
      rRouteResponse.headers['pong-header'] = 'silly-pong';
      rRouteResponse.value = pong();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = echoPathParam(
        (pathParams.getField('message')),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = echoQueryParam(
        message: (queryParams.getField('message')),
      );
      await rRouteResponse.writeResponse(request.response);
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
