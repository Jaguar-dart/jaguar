library jaguar.src.annotations;

import 'dart:async';

import 'package:jaguar/jaguar.dart';

part 'routes.dart';
part 'interceptors.dart';
part 'inputs.dart';
part 'exception.dart';

class Api {
  final String path;

  const Api({this.path: ''});
}

///An annotation to define an API group in API class
class IncludeApi {
  ///Path prefix to the group
  final String path;

  const IncludeApi({this.path: ''});
}

/// JaguarFile represents a file. The route handlers and interceptors can return
/// this type to return a filename instead of returning Strings.
class JaguarFile {
  /// Path of the file
  final String filePath;

  const JaguarFile(this.filePath);
}
