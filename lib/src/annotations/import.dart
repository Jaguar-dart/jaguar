library jaguar.src.annotations;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

part 'routes.dart';
part 'interceptors.dart';
part 'inputs.dart';
part 'exception.dart';

///An annotation to define an API class
class Api {
  final String path;
  final String version;

  const Api({this.path: '', this.version: ''});

  String get url {
    String prefix = "";
    if (path != null && path.isNotEmpty) {
      prefix += path;
    }
    if (version != null && version.isNotEmpty) {
      prefix += version;
    }

    return prefix;
  }
}

class RouteGroup {
  final String path;

  const RouteGroup({this.path: ''});
}

///An annotation to define an API group in API class
class Group {
  ///Path prefix to the group
  final String path;

  const Group({this.path: ''});
}

/// JaguarFile represents a file. The route handlers and interceptors can return
/// this type to return a filename instead of returning Strings.
class JaguarFile {
  /// Path of the file
  final String filePath;

  const JaguarFile(this.filePath);
}
