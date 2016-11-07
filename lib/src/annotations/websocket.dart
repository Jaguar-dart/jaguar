part of jaguar.src.annotations;

class Ws extends RouteBase {
  final String path;

  final List<String> methods;

  final int statusCode;

  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  final bool validatePathParams;

  final bool validateQueryParams;

  const Ws(this.path,
      {this.methods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ],
      this.statusCode: 200,
      this.headers,
      this.pathRegEx,
      this.validatePathParams: false,
      this.validateQueryParams: false});
}
