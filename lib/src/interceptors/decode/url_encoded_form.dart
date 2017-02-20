part of jaguar.src.interceptors;

class WrapDecodeUrlEncodedForm extends RouteWrapper<DecodeUrlEncodedForm> {
  final Encoding encoding;

  final String id;

  const WrapDecodeUrlEncodedForm({this.encoding, this.id});

  DecodeUrlEncodedForm createInterceptor() =>
      new DecodeUrlEncodedForm(encoding: this.encoding);
}

class DecodeUrlEncodedForm extends Interceptor {
  final Encoding encoding;

  const DecodeUrlEncodedForm({this.encoding: UTF8});

  Future<Map<String, String>> pre(Request request) async {
    return (await request.bodyAsText(encoding))
        .split("&")
        .map((String part) => part.split("="))
        .map((List<String> part) => <String, String>{part.first: part.last})
        .reduce((Map<String, String> value, Map<String, String> element) =>
            value..putIfAbsent(element.keys.first, () => element.values.first));
  }
}
