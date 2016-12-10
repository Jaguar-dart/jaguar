library example.routes;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

import 'package:jaguar/interceptors.dart';

import '../../common/models/book/book.dart';

part 'example_use_interceptor.g.dart';

class WrapSampleInterceptor implements RouteWrapper<SampleInterceptor> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapSampleInterceptor({this.id});

  SampleInterceptor createInterceptor() => new SampleInterceptor();
}

class SampleInterceptor implements Interceptor {
  SampleInterceptor();

  void pre() {
    print("Executes before request handler!");
  }

  void post() {
    print("Executes after request handler!");
  }
}

class NeedsHttpRequestInterceptor implements Interceptor {
  NeedsHttpRequestInterceptor();

  /// [HttpRequest] object of the current request is automatically provided when
  /// first argument of interceptor method is [HttpRequest]
  void pre(HttpRequest req) {
    print("Executes before request handler!");
  }

  /// [HttpRequest] object of the current request is automatically provided when
  /// first argument of interceptor method is [HttpRequest]
  void post(HttpRequest req) {
    print("Executes after request handler!");
  }
}

class InterceptorWithInput implements Interceptor {
  InterceptorWithInput();

  /// [Input] annotation can be used to request result from another interceptor.
  /// [resultFrom] argument of [Input] specifies which interceptor to get result from.
  @Input(DecodeJsonMap)
  void pre(HttpRequest req, Map body) {
    print("Executes before request handler!");
  }
}

@Api(path: '/api/book')
class BooksApi extends Object with _$JaguarBooksApi {
  /// A route can be wrapped with an interceptor by annotating the route with
  /// interceptor's wrapper. WrapEncodeToJson wrapper can be used to wrap EncodeToJson
  /// interceptor. EncodeToJson interceptor executes after route handler execution
  /// and converts the Map or List response returned by route to Json.
  @Get()
  @WrapEncodeToJson()
  Map getJaguarInfo() => {
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      };

  @Post()
  @WrapDecodeJsonMap()
  @Input(DecodeJsonMap)
  Map createJaguarInfo(Map body) => body;
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new BooksApi());

  await serve(configuration);
}
