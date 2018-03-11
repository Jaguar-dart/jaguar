library test.jaguar.interceptor.inject_request;

import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

part 'inject_input.g.dart';

class UsesRequest extends Interceptor {
  String output;

  before(Context ctx) {
    output = ctx.req.uri.toString();
    ctx.addInterceptor(UsesRequest, id, this);
  }
}

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  static UsesRequest usesRequest(Context ctx) => new UsesRequest();

  @Get(path: '/echo/uri')
  @Wrap(const [usesRequest])
  Response<String> getJaguarInfo(Context ctx) => Response.json({
        'Uri': ctx.getInterceptorResult(UsesRequest),
      });
}

void main() {
  group('Inject input:Generated', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new ExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });

  group('Inject input:Reflect', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(reflect(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });
}

grouped() {
  test('inject request', () async {
    await resty.get('/api/echo/uri').authority('http://localhost:8000').exact(
        statusCode: 200,
        mimeType: MimeType.json,
        body: r'{"Uri":"/api/echo/uri"}');
  });
}
