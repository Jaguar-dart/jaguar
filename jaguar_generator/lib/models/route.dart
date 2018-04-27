part of jaguar_generator.models;

class RouteMethod {
  String name;

  String returnType;

  bool returnsVoid;

  bool returnsResponse;

  String jaguarResponseType;

  bool isAsync;
}

class Route {
  /// Instantiation of Jaguar Route object
  String instantiation;

  //ant.RouteBase value;

  List<InterceptorCreatorFunc> interceptors = <InterceptorCreatorFunc>[];

  RouteMethod method;

  List<ExceptionHandler> exceptions = <ExceptionHandler>[];

  int respIndex;
}

class Group {
  String path;

  String type;

  String name;
}
