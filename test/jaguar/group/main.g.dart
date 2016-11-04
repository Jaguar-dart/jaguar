// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements ApiInterface {
  static const List<Route> _routes = const <Route>[
    const Route('/version', methods: const <String>['GET']),
    const Route('', methods: const <String>['GET']),
    const Route('/statuscode', methods: const <String>['GET'], statusCode: 201),
    const Route('', methods: const <String>['GET']),
    const Route('/some/:param1', methods: const <String>['POST'])
  ];

  UserApi get user;
  BookApi get book;

  String statusCode();

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams();
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);
    bool match = false;

    match =
        _routes[0].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = statusCode();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[1]
        .match(request.uri.path, request.method, '/api/user', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = user.getUser();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[2]
        .match(request.uri.path, request.method, '/api/user', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = user.statusCode();
      request.response.statusCode = 201;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[3]
        .match(request.uri.path, request.method, '/api/book', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = book.getBook();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match = _routes[4]
        .match(request.uri.path, request.method, '/api/book', pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = book.some(
        (pathParams.getField('param1')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}
