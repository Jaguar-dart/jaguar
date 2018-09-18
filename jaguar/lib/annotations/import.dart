/// Annotations
library jaguar.src.annotations;

import 'dart:convert' as converters;

import 'package:jaguar/jaguar.dart';

part 'methods.dart';

/// Annotates a class that it is an API class that contains route handlers
class GenController {
  /// Path prefix of the child routes and included APIs in the API class
  final String path;

  const GenController({this.path: ''});
}

/// Includes the route handlers into the parent API class
class IncludeController {
  ///Path prefix for the route handlers of the Included API
  final String path;

  const IncludeController({this.path: ''});
}
