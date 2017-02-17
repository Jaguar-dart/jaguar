library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import 'package:jaguar/interceptors.dart';

part 'use_interceptor.g.dart';

@Api(path: '/api/book')
class BooksApi {
  WrapEncodeToJson jsonEncoder() => new WrapEncodeToJson();
  WrapDecodeJsonMap jsonDecoder() => new WrapDecodeJsonMap();

  /// A route can be wrapped with interceptors using [InterceptWith] annotation. The
  /// annotation takes list of fields in the controller class that provide [RouteWrapper]s.
  ///
  /// In this case [EncodeToJson] is wrapped around the route.
  @Get()
  @InterceptWith(const [#jsonEncoder])
  Map getJaguarInfo() => {
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      };

  /// An example showing wrapping multiple interceptors around a route
  @Post()
  @InterceptWith(const [#jsonEncoder, #jsonDecoder])
  Map createJaguarInfo(@Input(DecodeJsonMap) Map body) => body;
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi());

  await jaguar.serve();
}
