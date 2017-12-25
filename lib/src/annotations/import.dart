/// Annotations
library jaguar.src.annotations;

import 'dart:async';

import 'package:jaguar/jaguar.dart';

part 'exception.dart';
part 'interceptors.dart';
part 'routes.dart';

/// Annotates a class that it is an API class that contains route handlers
class Api {
  /// Path prefix of the child routes and included APIs in the API class
  final String path;

  final bool isRoot;

  const Api({this.path: '', this.isRoot: false});
}

/// Includes the route handlers into the parent API class
class IncludeApi {
  ///Path prefix for the route handlers of the Included API
  final String path;

  const IncludeApi({this.path: ''});
}
