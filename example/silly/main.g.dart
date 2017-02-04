// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.example.silly;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class MyGroup
// **************************************************************************

abstract class _$JaguarMyGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get(path: '/')];

  String get();

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/myGroup';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for get
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = get();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class MySecondGroup
// **************************************************************************

abstract class _$JaguarMySecondGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get(path: '/')];

  String get();

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/mySecondGroup';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for get
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = get();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
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

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for ping
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = ping();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for pong
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 201;
        rRouteResponse0.headers['pong-header'] = 'silly-pong';
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = pong();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for echoPathParam
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = echoPathParam(
          (pathParams.getField('message')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for echoQueryParam
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = echoQueryParam(
          message: (queryParams.getField('message')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for websocket
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      try {
        WebSocket ws = await request.upgradeToWebSocket;
        await websocket(
          ws,
        );
      } catch (e) {
        rethrow;
      }
    }

    {
      Response response = await myGroup.handleRequest(request, prefix: prefix);
      if (response is Response) {
        return response;
      }
    }

    {
      Response response =
          await mySecondGroup.handleRequest(request, prefix: prefix);
      if (response is Response) {
        return response;
      }
    }

    return null;
  }
}
