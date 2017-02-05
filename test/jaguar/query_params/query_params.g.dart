// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.query_params;

// **************************************************************************
// Generator: ApiGenerator
// Target: class QueryParamsExampleApi
// **************************************************************************

class JaguarQueryParamsExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/stringParam'),
    const Get(path: '/intParam'),
    const Get(path: '/doubleParam'),
    const Get(path: '/numParam'),
    const Get(path: '/defStringParam'),
    const Get(path: '/defIntParam'),
    const Get(path: '/defDoubleParam'),
    const Get(path: '/defNumParam')
  ];

  final QueryParamsExampleApi _internal;

  factory JaguarQueryParamsExampleApi() {
    final instance = new QueryParamsExampleApi();
    return new JaguarQueryParamsExampleApi.from(instance);
  }
  JaguarQueryParamsExampleApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for stringParam
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.stringParam(
          strParam: (queryParams.getField('strParam')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for intParam
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.intParam(
          intParam: stringToInt(queryParams.getField('intParam')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for doubleParam
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.doubleParam(
          doubleParam: stringToNum(queryParams.getField('doubleParam')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for numParam
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.numParam(
          numParam: stringToNum(queryParams.getField('numParam')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for defStringParam
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.defStringParam(
          strParam: (queryParams.getField('strParam')) ?? 'default',
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for defIntParam
    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.defIntParam(
          intParam: stringToInt(queryParams.getField('intParam')) ?? 50,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for defDoubleParam
    match =
        routes[6].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.defDoubleParam(
          doubleParam:
              stringToNum(queryParams.getField('doubleParam')) ?? 12.75,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for defDumParam
    match =
        routes[7].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.defDumParam(
          numParam: stringToNum(queryParams.getField('numParam')) ?? 5.25,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
