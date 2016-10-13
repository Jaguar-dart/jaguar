// GENERATED CODE - DO NOT MODIFY BY HAND

part of source_gen.test.example;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithoutParam
// **************************************************************************

abstract class _$JaguarApiWithoutParam {
  List<RouteInformations> _routes = <RouteInformations>[];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithName
// **************************************************************************

abstract class _$JaguarApiWithName {
  List<RouteInformations> _routes = <RouteInformations>[];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithVersion
// **************************************************************************

abstract class _$JaguarApiWithVersion {
  List<RouteInformations> _routes = <RouteInformations>[];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithNameAndVersion
// **************************************************************************

abstract class _$JaguarApiWithNameAndVersion {
  List<RouteInformations> _routes = <RouteInformations>[];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithoutParamWithSimpleRoute
// **************************************************************************

abstract class _$JaguarApiWithoutParamWithSimpleRoute {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(
        r"/ping", ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      ping();
      return true;
    }
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithoutParamWithFutureRoute
// **************************************************************************

abstract class _$JaguarApiWithoutParamWithFutureRoute {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(
        r"/ping", ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      await ping();
      return true;
    }
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithoutParamWithFutureRouteWithHttpRequest
// **************************************************************************

abstract class _$JaguarApiWithoutParamWithFutureRouteWithHttpRequest {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(
        r"/ping", ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      await ping(
        request,
      );
      return true;
    }
    return false;
  }
}
