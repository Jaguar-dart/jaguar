// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.route;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
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
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getUser();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for statusCode
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 201;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.statusCode();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for paramAndQuery
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.paramAndQuery(
          (pathParams.getField('param')),
          query: (queryParams.getField('query')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for inputHeader
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.inputHeader(
          request.headers.value('user'),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for inputHeaders
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.inputHeaders(
          request.headers,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for inputCookie
    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.inputCookie(
          request.cookies
              .firstWhere((cookie) => cookie.name == 'user', orElse: () => null)
              ?.value,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for inputCookies
    match =
        routes[6].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.inputCookies(
          request.cookies,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
