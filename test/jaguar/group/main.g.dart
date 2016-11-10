// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class UserApi
// **************************************************************************

abstract class _$JaguarUserApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route('', methods: const <String>['GET']),
    const Route('/statuscode', methods: const <String>['GET'], statusCode: 201)
  ];

  String getUser();

  String statusCode();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = getUser();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = statusCode();
      request.response.statusCode = 201;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route('/version', methods: const <String>['GET'])
  ];

  UserApi get user;
  BookApi get book;

  String statusCode();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = statusCode();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    if (await user.handleRequest(request, prefix: prefix + '/user')) {
      return true;
    }

    if (await book.handleRequest(request, prefix: prefix + '/book')) {
      return true;
    }

    return false;
  }
}
