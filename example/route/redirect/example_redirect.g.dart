// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class RedirectExampleApi
// **************************************************************************

class JaguarRedirectExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/tome'),
    const Get(path: '/redirectme', statusCode: HttpStatus.MOVED_PERMANENTLY),
    const Get(
        path: '/redirectme/withquery', statusCode: HttpStatus.MOVED_PERMANENTLY)
  ];

  final RedirectExampleApi _internal;

  factory JaguarRedirectExampleApi() {
    final instance = new RedirectExampleApi();
    return new JaguarRedirectExampleApi.from(instance);
  }
  JaguarRedirectExampleApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    ContextImpl ctx = new ContextImpl(request);
    bool match = false;

//Handler for getBookById
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getBookById(
          (ctx.pathParams.getField('id')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for redirectMe
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<Uri> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 301;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.redirectMe();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for redirectWithQuery
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<Uri> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 301;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.redirectWithQuery();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
