part of jaguar.src.interceptors;

class WrapEncodeToJson implements RouteWrapper<EncodeToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeToJson({this.id});

  EncodeToJson createInterceptor() => new EncodeToJson();
}

class EncodeToJson extends Interceptor {
  EncodeToJson();

  @InputRouteResponse()
  Response<String> post(Response incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value);
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

class WrapEncodeMapToJson implements RouteWrapper<EncodeMapToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeMapToJson({this.id});

  EncodeMapToJson createInterceptor() => new EncodeMapToJson();
}

class EncodeMapToJson extends Interceptor {
  EncodeMapToJson();

  @InputRouteResponse()
  Response<String> post(Response<Map> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value);
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

class WrapEncodeListToJson implements RouteWrapper<EncodeListToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeListToJson({this.id});

  EncodeListToJson createInterceptor() => new EncodeListToJson();
}

class EncodeListToJson extends Interceptor {
  EncodeListToJson();

  @InputRouteResponse()
  Response<String> post(Response<List> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value);
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

class WrapEncodeJsonable implements RouteWrapper<EncodeJsonable> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeJsonable({this.id});

  EncodeJsonable createInterceptor() => new EncodeJsonable();
}

class EncodeJsonable extends Interceptor {
  EncodeJsonable();

  @InputRouteResponse()
  Response<String> post(Response<ToJsonable> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = incoming.value.toJson();
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}
