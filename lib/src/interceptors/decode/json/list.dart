part of jaguar.src.interceptors;

class WrapDecodeJsonList implements RouteWrapper<DecodeJsonList> {
  final Encoding encoding;

  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapDecodeJsonList({this.encoding: UTF8, this.id});

  DecodeJsonList createInterceptor() => new DecodeJsonList(encoding: encoding);
}

class DecodeJsonList extends Interceptor {
  final Encoding encoding;

  const DecodeJsonList({this.encoding: UTF8});

  Future<List> pre(Request request) async {
    String data = await request.bodyAsText(encoding);
    if (data.isNotEmpty) {
      dynamic ret = JSON.decode(data);
      if (ret is! List) {
        throw new FormatException('List expect, ${ret.runtimeType} found!');
      }

      return ret;
    }

    return null;
  }
}
