library example.routes;

import 'dart:io' show HttpStatus;
import 'dart:async';
import 'package:jaguar/jaguar.dart';

import '../../common/models/book/book.dart';

part 'example_redirect.g.dart';

@Api(path: '/api')
class RedirectExampleApi extends _$JaguarRedirectExampleApi
    implements RequestHandler {
  /// Target route for redirection
  @Get(path: '/tome')
  String getBookById(String id) => "Hey there!";

  /// Simple redirect
  @Get(path: '/redirectme', statusCode: HttpStatus.MOVED_PERMANENTLY)
  Uri redirectMe() => new Uri(path: '/api/tome');

  /// Simple redirect
  @Get(path: '/redirectme/withquery', statusCode: HttpStatus.MOVED_PERMANENTLY)
  Uri redirectWithQuery() =>
      new Uri(path: '/api/tome', queryParameters: {'hello': 'dart'});
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new RedirectExampleApi());

  await serve(configuration);
}
