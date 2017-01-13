// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class UserApi
// **************************************************************************

abstract class _$JaguarUserApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(
        path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  ];

  String getUser();

  String statusCode();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.value = getUser();
        await rRouteResponse0.writeResponse(request.response);
      } catch (e) {
        rethrow;
      }
      return true;
    }

//Handler for statusCode
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 201;
        rRouteResponse0.value = statusCode();
        await rRouteResponse0.writeResponse(request.response);
      } catch (e) {
        rethrow;
      }
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

//Handler for statusCode
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.value = statusCode();
        await rRouteResponse0.writeResponse(request.response);
      } catch (e) {
        rethrow;
      }
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
