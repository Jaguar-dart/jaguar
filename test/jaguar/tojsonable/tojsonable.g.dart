// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.query_params;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ToJsonableExampleApi
// **************************************************************************

class JaguarToJsonableExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/EncodeJsonable/object'),
    const Get(path: '/EncodeJsonable/list'),
    const Get(path: '/EncodeJsonableObject'),
    const Get(path: '/EncodeJsonableList')
  ];

  final ToJsonableExampleApi _internal;

  factory JaguarToJsonableExampleApi() {
    final instance = new ToJsonableExampleApi();
    return new JaguarToJsonableExampleApi.from(instance);
  }
  JaguarToJsonableExampleApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    ContextImpl ctx = new ContextImpl(request);
    bool match = false;

//Handler for encodeJsonable_object
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<Model> rRouteResponse0 = new Response(null);
      EncodeJsonable iEncodeJsonable0;
      try {
        final RouteWrapper wEncodeJsonable0 = _internal.jsonEncoder();
        iEncodeJsonable0 = wEncodeJsonable0.createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.encodeJsonable_object();
        Response<String> rRouteResponse1 = iEncodeJsonable0.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonable0?.onException();
        rethrow;
      }
    }

//Handler for encodeJsonable_list
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      EncodeJsonable iEncodeJsonable0;
      try {
        final RouteWrapper wEncodeJsonable0 = _internal.jsonEncoder();
        iEncodeJsonable0 = wEncodeJsonable0.createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.encodeJsonable_list();
        Response<String> rRouteResponse1 = iEncodeJsonable0.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonable0?.onException();
        rethrow;
      }
    }

//Handler for encodeJsonableObject
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<Model> rRouteResponse0 = new Response(null);
      EncodeJsonable iEncodeJsonable0;
      try {
        final RouteWrapper wEncodeJsonable0 = _internal.jsonEncoder();
        iEncodeJsonable0 = wEncodeJsonable0.createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.encodeJsonableObject();
        Response<String> rRouteResponse1 = iEncodeJsonable0.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonable0?.onException();
        rethrow;
      }
    }

//Handler for encodeJsonableList
    match = routes[3]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      EncodeJsonable iEncodeJsonable0;
      try {
        final RouteWrapper wEncodeJsonable0 = _internal.jsonEncoder();
        iEncodeJsonable0 = wEncodeJsonable0.createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.encodeJsonableList();
        Response<String> rRouteResponse1 = iEncodeJsonable0.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonable0?.onException();
        rethrow;
      }
    }

    return null;
  }
}
