library test.jaguar.route;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@Controller()
class ExampleController {
  @HttpMethod(path: '/hello', methods: const <String>['GET'])
  void hello(Context ctx) => ctx.response = new StrResponse('Hello world!');

  @Get(path: '/returnValue')
  String returnValue(Context ctx) => 'Hello world, Champ!';

  @Get(path: '/returnResponse')
  Response<int> returnResponse(Context ctx) => new Response(5);

  @Post(path: '/')
  String post(_) => 'Post';

  @Put(path: '/')
  String put(_) => 'Put';

  @Delete(path: '/')
  String delete(_) => 'Delete';

  @GetJson(path: '/json')
  Map getJson(_) => {'method': 'get'};

  @PostJson(path: '/json')
  Map postJson(_) => {'method': 'post'};

  @PutJson(path: '/json')
  Map putJson(_) => {'method': 'put'};

  @DeleteJson(path: '/json')
  Map deleteJson(_) => {'method': 'delete'};
}

void main() {
  resty.globalClient = new http.IOClient();

  group('Controller', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server.add(reflect(new ExampleController()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('GET.SetResponse', () async {
      await resty
          .get('/hello')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
    });

    test('GET.ReturnValue', () async {
      await resty.get('/returnValue').authority('http://localhost:10000').exact(
          statusCode: 200, mimeType: 'text/plain', body: 'Hello world, Champ!');
    });

    test('GET.ReturnResponse', () async {
      await resty
          .get('/returnResponse')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '5');
    });

    test('Post', () async {
      await resty
          .post('/')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Post');
    });

    test('Put', () async {
      await resty
          .put('/')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Put');
    });

    test('Delete', () async {
      await resty
          .delete('/')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Delete');
    });

    test('GetJson', () async {
      await resty.get('/json').authority('http://localhost:10000').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"get"}');
    });

    test('PostJson', () async {
      await resty.post('/json').authority('http://localhost:10000').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"post"}');
    });

    test('PutJson', () async {
      await resty.put('/json').authority('http://localhost:10000').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"put"}');
    });

    test('DeleteJson', () async {
      await resty.delete('/json').authority('http://localhost:10000').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"delete"}');
    });
  });
}
