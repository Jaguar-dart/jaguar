library jaguar.src.annotations;

import 'dart:async';

import 'package:jaguar/jaguar.dart';

part 'exception.dart';
part 'interceptors.dart';
part 'routes.dart';

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
