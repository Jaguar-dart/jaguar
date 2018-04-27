// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.exception.exception;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/user'),
    const Post(path: '/user')
  ];

  String getUser(Context ctx);

  User post(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getUser
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      try {
        return new Response.fromRoute(getUser(ctx), routes[0]);
      } catch (e, s) {
        {
          ValidationExceptionHandler handler = new ValidationExceptionHandler();
          final exResp = await handler.onRouteException(ctx, e, s);
          if (exResp != null) return exResp;
        }
        {
          CustomExceptionHandler handler = new CustomExceptionHandler();
          final exResp = await handler.onRouteException(ctx, e, s);
          if (exResp != null) return exResp;
        }
        rethrow;
      }
    }

//Handler for post
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      try {
        ctx.before.add(userParser);
        return await Do.chain(ctx, post, routes[1]);
      } catch (e, s) {
        {
          ValidationExceptionHandler handler = new ValidationExceptionHandler();
          final exResp = await handler.onRouteException(ctx, e, s);
          if (exResp != null) return exResp;
        }
        rethrow;
      }
    }

    return null;
  }
}
