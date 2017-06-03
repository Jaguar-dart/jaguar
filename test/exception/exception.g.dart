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

  JaguarExampleApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    final ctx = new Context(request);
    bool match = false;

//Handler for getUser
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      try {
        final interceptors = <Interceptor>[];
        return await Interceptor.chain(
            ctx, interceptors, _internal.getUser, routes[0]);
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
      try {
        final interceptors = <Interceptor>[];
        interceptors.add(_internal.userParser(ctx));
        return await Interceptor.chain(
            ctx, interceptors, _internal.post, routes[1]);
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        return await handler.onRouteException(request, e, s);
      }
    }

    return null;
  }
}
