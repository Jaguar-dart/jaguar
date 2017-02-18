library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import 'package:jaguar/interceptors.dart';

part 'inject_request.g.dart';

class WrapUsesRequest extends RouteWrapper<UsesRequest> {
  UsesRequest createInterceptor() => new UsesRequest();
}

class UsesRequest extends Interceptor {
  /// [Request] object of the current request is automatically provided when
  /// first argument of interceptor method is [Request]
  void pre(Request req) {
    print("Executes before request handler on path: ${req.uri}!");
  }

  /// [Request] object of the current request is automatically provided when
  /// first argument of interceptor method is [Request]
  void post(Request req) {
    print("Executes after request handler on path: ${req.uri}!");
  }
}

@Api(path: '/api/book')
class BooksApi {
  WrapUsesRequest usesRequest() => new WrapUsesRequest();

  WrapEncodeToJson jsonEncoder() => new WrapEncodeToJson();

  @Get()
  @Wrap(const [#jsonEncoder, #usesRequest])
  Map getJaguarInfo() => {
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      };
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi());

  await jaguar.serve();
}
