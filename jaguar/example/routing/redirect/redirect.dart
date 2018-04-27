library example.routes;

import 'dart:io' show HttpStatus;
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@Api(path: '/api')
class RedirectExampleApi {
  /// Target route for redirection
  @Get(path: '/tome')
  String getBookById(Context ctx) => "Hey there!";

  /// Simple redirect
  @Get(path: '/redirectme', statusCode: HttpStatus.MOVED_PERMANENTLY)
  Uri redirectMe(Context ctx) => new Uri(path: '/api/tome');

  /// Simple redirect
  @Get(path: '/redirectme/withquery', statusCode: HttpStatus.MOVED_PERMANENTLY)
  Uri redirectWithQuery(Context ctx) =>
      new Uri(path: '/api/tome', queryParameters: {'hello': 'dart'});
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(reflect(new RedirectExampleApi()));

  await jaguar.serve();
}
