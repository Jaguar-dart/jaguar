/// Annotations
library jaguar.src.annotations;

import 'dart:convert' as converters;

import 'package:jaguar/jaguar.dart';

part 'interceptors.dart';
part 'routes.dart';

/// Annotates a class that it is an API class that contains route handlers
class Controller {
  /// Path prefix of the child routes and included APIs in the API class
  final String path;

  final bool isRoot;

  const Controller({this.path: '', this.isRoot: false});
}

/// Includes the route handlers into the parent API class
class IncludeHandler {
  ///Path prefix for the route handlers of the Included API
  final String path;

  const IncludeHandler({this.path: ''});
}
