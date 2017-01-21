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

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = getUser();
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
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = statusCode();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
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

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
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
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = statusCode();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    {
      Response response =
          await user.handleRequest(request, prefix: prefix + '/user');
      if (response is Response) {
        return response;
      }
    }

    {
      Response response =
          await book.handleRequest(request, prefix: prefix + '/book');
      if (response is Response) {
        return response;
      }
    }

    return null;
  }
}
