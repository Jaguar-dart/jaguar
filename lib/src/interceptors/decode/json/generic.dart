part of jaguar.src.interceptors;

class WrapDecodeJson implements RouteWrapper<DecodeJson> {
  final Encoding encoding;

  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapDecodeJson({this.encoding: UTF8, this.id});

  DecodeJson createInterceptor() => new DecodeJson(encoding: this.encoding);
}

class DecodeJson extends Interceptor {
  final Encoding encoding;

  DecodeJson({this.encoding: UTF8});

  Future<dynamic> pre(Request request) async {
    final String data = await request.bodyAsText(encoding);
    if (data.isNotEmpty) {
      return JSON.decode(data);
    }
    return null;
  }
}
