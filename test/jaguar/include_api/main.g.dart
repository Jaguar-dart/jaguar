// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarUserApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(
        path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  ];

  String getUser(Context ctx);
  String statusCode(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    bool match = false;

//Handler for getUser
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getUser, routes[0]);
    }

//Handler for statusCode
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, statusCode, routes[1]);
    }

    return null;
  }
}

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/version', methods: const <String>['GET'])
  ];

  String statusCode(Context ctx);

  UserApi get user;
  BookApi get book;

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for statusCode
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, statusCode, routes[0]);
    }

    {
      Response response =
          await user.handleRequest(ctx, prefix: prefix + '/user');
      if (response is Response) {
        return response;
      }
    }

    {
      Response response =
          await book.handleRequest(ctx, prefix: prefix + '/book');
      if (response is Response) {
        return response;
      }
    }

    return null;
  }
}
