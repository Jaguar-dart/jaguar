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
  Response pre(Response resp) {
    resp.value = JSON.encode(resp.value);
    return resp;
  }
}
