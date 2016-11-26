// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class UserApi
// **************************************************************************

abstract class _$JaguarUserApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  ];

  String getUser();

  String statusCode();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getUser();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 201;
      rRouteResponse.value = statusCode();
      await rRouteResponse.writeResponse(request.response);
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
    const Route(path: '/version', methods: const <String>['GET'])
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
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = statusCode();
      await rRouteResponse.writeResponse(request.response);
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
