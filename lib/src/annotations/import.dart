library jaguar.src.annotations;

import 'dart:io';

part 'routes.dart';
part 'interceptors.dart';
part 'inputs.dart';

///An annotation to define an API class
class Api {
  final String path;

  const Api({this.path: ''});

  String get url {
    String prefix = "";
    if (path != null && path.isNotEmpty) {
      prefix += path;
    }

    return prefix;
  }
}

///An annotation to define an API group in API class
class Group {
  ///Path prefix to the group
  final String path;

  const Group({this.path});
}

class ExceptionHandler {
  final Type exception;

  const ExceptionHandler(this.exception);
}

typedef dynamic ExceptionHandlerFunc(
    HttpRequest request, dynamic e, StackTrace trace);
