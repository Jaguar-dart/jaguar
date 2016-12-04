part of jaguar.src.interceptors;

class DecodeUrlEncodedForm extends Interceptor {
  final Encoding encoding;

  const DecodeUrlEncodedForm({this.encoding: UTF8});

  Future<Map<String, String>> pre(HttpRequest request) async {
    return (await getStringFromBody(request, encoding))
        .split("&")
        .map((String part) => part.split("="))
        .map((List<String> part) => <String, String>{part.first: part.last})
        .reduce((Map<String, String> value, Map<String, String> element) =>
            value..putIfAbsent(element.keys.first, () => element.values.first));
  }
}
