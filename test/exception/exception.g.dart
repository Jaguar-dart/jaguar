// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.exception.exception;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/user'),
    const Post(path: '/user')
  ];

  final ExampleApi _internal;

  factory JaguarExampleApi() {
    final instance = new ExampleApi();
    return new JaguarExampleApi.from(instance);
  }
  JaguarExampleApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    ContextImpl ctx = new ContextImpl(request);
    bool match = false;

//Handler for getUser
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        try {
          rRouteResponse0.statusCode = 200;
          rRouteResponse0.headers
              .set('content-type', 'text/plain; charset=utf-8');
          rRouteResponse0.value = _internal.getUser(
            who: (ctx.queryParams.getField('who')),
          );
          return rRouteResponse0;
        } catch (e) {
          rethrow;
        }
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        return await handler.onRouteException(request, e, s);
      } on CustomException catch (e, s) {
        CustomExceptionHandler handler = new CustomExceptionHandler();
        return await handler.onRouteException(request, e, s);
      }
    }

//Handler for post
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<User> rRouteResponse0 = new Response(null);
      try {
        UserParser iUserParser0;
        try {
          final RouteWrapper wUserParser0 = _internal.userParser();
          iUserParser0 = wUserParser0.createInterceptor();
          User rUserParser0 = iUserParser0.pre(
            ctx.queryParams,
          );
          ctx.addOutput(
              UserParser, wUserParser0.id, iUserParser0, rUserParser0);
          rRouteResponse0.statusCode = 200;
          rRouteResponse0.headers
              .set('content-type', 'text/plain; charset=utf-8');
          rRouteResponse0.value = _internal.post(
            ctx.getInput(UserParser),
          );
          return rRouteResponse0;
        } catch (e) {
          await iUserParser0?.onException();
          rethrow;
        }
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        return await handler.onRouteException(request, e, s);
      }
    }

    return null;
  }
}
