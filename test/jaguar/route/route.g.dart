// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.route;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements ApiInterface {
  static const List<Route> _routes = const <Route>[
    const Route('/user', methods: const <String>['GET']),
    const Route('/statuscode', methods: const <String>['GET'], statusCode: 201),
    const Route('/input/header', methods: const <String>['GET']),
    const Route('/input/headers', methods: const <String>['GET']),
    const Route('/input/cookie', methods: const <String>['GET']),
    const Route('/input/cookies', methods: const <String>['GET'])
  ];

  String getUser();

  String statusCode();

  String inputHeader(String user);

  String inputHeaders(HttpHeaders headers);

  String inputCookie(String user);

  String inputCookies(List<Cookie> cookies);

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams();
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);
    bool match = false;

    match =
        _routes[0].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = getUser();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[1].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = statusCode();
      request.response.statusCode = 201;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[2].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = inputHeader(
        request.headers.value('user'),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[3].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = inputHeaders(
        request.headers,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[4].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = inputCookie(
        request.cookies
            .firstWhere((cookie) => cookie.name == 'user', orElse: () => null)
            ?.value,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[5].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = inputCookies(
        request.cookies,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}
