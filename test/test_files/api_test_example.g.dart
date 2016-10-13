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
// Target: class ApiWithoutParamWithSimpleRouteWithHttpRequest
// **************************************************************************

abstract class _$JaguarApiWithoutParamWithSimpleRouteWithHttpRequest {
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
      ping(
        request,
      );
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

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithNameWithSimpleRoute
// **************************************************************************

abstract class _$JaguarApiWithNameWithSimpleRoute {
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
// Target: class ApiWithNameAndVersionWithSimpleRoute
// **************************************************************************

abstract class _$JaguarApiWithNameAndVersionWithSimpleRoute {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(
        r"/api/v1/ping", ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
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
// Target: class ApiWithGroup
// **************************************************************************

abstract class _$JaguarApiWithGroup {
  List<RouteInformations> _routes = <RouteInformations>[];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiWithGroupWithSimpleRoute
// **************************************************************************

abstract class _$JaguarApiWithGroupWithSimpleRoute {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(
        r"/myGroup/ping", ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      myGroup.ping();
      return true;
    }
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiAndRouteWithParam
// **************************************************************************

abstract class _$JaguarApiAndRouteWithParam {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(r"/users/([a-zA-Z])",
        ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      ping(
        args[0],
      );
      return true;
    }
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiAndRouteWithHttpRequestAndParam
// **************************************************************************

abstract class _$JaguarApiAndRouteWithHttpRequestAndParam {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(r"/users/([a-zA-Z])",
        ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      ping(
        request,
        args[0],
      );
      return true;
    }
    return false;
  }
}

// **************************************************************************
// Generator: ApiGenerator
// Target: class ApiAndRouteWithQueryParameter
// **************************************************************************

abstract class _$JaguarApiAndRouteWithQueryParameter {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(
        r"/users", ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      ping(name: request.uri.queryParameters['name']);
      return true;
    }
    return false;
  }
}
