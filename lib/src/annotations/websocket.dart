part of jaguar.src.annotations;

class Ws extends RouteBase {
  final String path;

  final List<String> methods = _methods;

  final int statusCode = 200;

  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  final bool validatePathParams;

  final bool validateQueryParams;

  const Ws(this.path,
      {this.headers,
      this.pathRegEx,
      this.validatePathParams: false,
      this.validateQueryParams: false});

  static const List<String> _methods = const <String>['GET'];
}
