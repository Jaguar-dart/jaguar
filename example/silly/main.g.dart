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

//Handler for get
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = get();
      await rRouteResponse0.writeResponse(request.response);
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

//Handler for get
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = get();
      await rRouteResponse0.writeResponse(request.response);
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
    const Put(
        path: '/pong',
        statusCode: 201,
        headers: const {"pong-header": "silly-pong"}),
    const Route(
        path: '/echo/pathparam/:message', methods: const <String>['POST']),
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

//Handler for ping
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = ping();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for pong
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 201;
      rRouteResponse0.headers['pong-header'] = 'silly-pong';
      rRouteResponse0.value = pong();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for echoPathParam
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = echoPathParam(
        (pathParams.getField('message')),
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for echoQueryParam
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = echoQueryParam(
        message: (queryParams.getField('message')),
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for websocket
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      WebSocket ws = await WebSocketTransformer.upgrade(request);
      await websocket(
        ws,
      );
      return true;
    }

    if (await myGroup.handleRequest(request, prefix: prefix)) {
      return true;
    }

    if (await mySecondGroup.handleRequest(request, prefix: prefix)) {
      return true;
    }

    return false;
  }
}
