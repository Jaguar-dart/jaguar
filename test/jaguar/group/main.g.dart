// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class UserApi
// **************************************************************************

class JaguarUserApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(
        path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  ];

  final UserApi _internal;

  factory JaguarUserApi() {
    final instance = new UserApi();
    return new JaguarUserApi.from(instance);
  }
  JaguarUserApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      ContextImpl ctx = new ContextImpl(request, pathParams);
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
      ContextImpl ctx = new ContextImpl(request, pathParams);
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

  factory JaguarExampleApi() {
    final instance = new ExampleApi();
    return new JaguarExampleApi.from(instance);
  }
  JaguarExampleApi.from(this._internal)
      : _userInternal = new JaguarUserApi.from(_internal.user),
        _bookInternal = new JaguarBookApi.from(_internal.book);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for statusCode
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      ContextImpl ctx = new ContextImpl(request, pathParams);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.statusCode();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    {
      Response response =
          await _userInternal.handleRequest(request, prefix: prefix + '/user');
      if (response is Response) {
        return response;
      }
    }

    {
      Response response =
          await _bookInternal.handleRequest(request, prefix: prefix + '/book');
      if (response is Response) {
        return response;
      }
    }

    return null;
  }
}
