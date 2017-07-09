// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: ApiGenerator
// Target: class UserApi
// **************************************************************************

class JaguarUserApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(
        path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  ];

  final UserApi _internal;

  JaguarUserApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    bool match = false;

//Handler for getUser
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.getUser, routes[0]);
    }

//Handler for statusCode
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.statusCode, routes[1]);
    }

    return null;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/version', methods: const <String>['GET'])
  ];

  final ExampleApi _internal;
  final JaguarUserApi _userInternal;
  final JaguarBookApi _bookInternal;

  JaguarExampleApi(this._internal)
      : _userInternal = new JaguarUserApi(_internal.user),
        _bookInternal = new JaguarBookApi(_internal.book);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for statusCode
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.statusCode, routes[0]);
    }

    {
      Response response =
          await _userInternal.handleRequest(ctx, prefix: prefix + '/user');
      if (response is Response) {
        return response;
      }
    }

    {
      Response response =
          await _bookInternal.handleRequest(ctx, prefix: prefix + '/book');
      if (response is Response) {
        return response;
      }
    }

    return null;
  }
}
