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

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getUser
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      try {
        return await Interceptor.chain(
            ctx, ctx.interceptorCreators, _internal.getUser, routes[0]);
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        return await handler.onRouteException(ctx, e, s);
      } on CustomException catch (e, s) {
        CustomExceptionHandler handler = new CustomExceptionHandler();
        return await handler.onRouteException(ctx, e, s);
      }
    }

//Handler for post
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      try {
        ctx.addInterceptor(_internal.userParser);
        return await Interceptor.chain(
            ctx, ctx.interceptorCreators, _internal.post, routes[1]);
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        return await handler.onRouteException(ctx, e, s);
      }
    }

    return null;
  }
}
