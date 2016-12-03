// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.route;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/user', methods: const <String>['GET']),
    const Route(
        path: '/statuscode', methods: const <String>['GET'], statusCode: 201),
    const Route(path: '/paramandquery/:param', methods: const <String>['GET']),
    const Route(path: '/input/header', methods: const <String>['GET']),
    const Route(path: '/input/headers', methods: const <String>['GET']),
    const Route(path: '/input/cookie', methods: const <String>['GET']),
    const Route(path: '/input/cookies', methods: const <String>['GET'])
  ];

  String getUser();

  String statusCode();

  String paramAndQuery(String param, {String query});

  String inputHeader(String user);

  String inputHeaders(HttpHeaders headers);

  String inputCookie(String user);

  String inputCookies(List<Cookie> cookies);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getUser();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for statusCode
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 201;
      rRouteResponse.value = statusCode();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for paramAndQuery
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = paramAndQuery(
        (pathParams.getField('param')),
        query: (queryParams.getField('query')),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for inputHeader
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = inputHeader(
        request.headers.value('user'),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for inputHeaders
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = inputHeaders(
        request.headers,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for inputCookie
    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = inputCookie(
        request.cookies
            .firstWhere((cookie) => cookie.name == 'user', orElse: () => null)
            ?.value,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for inputCookies
    match =
        routes[6].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = inputCookies(
        request.cookies,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
