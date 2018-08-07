library test.jaguar.route.mux;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = new http.IOClient();

  group('mux', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..get('/hello', (ctx) {
          ctx.response = Response('Hello world!');
        })
        ..get('/returnValue', (ctx) => 'Hello world, Champ!')
        ..get('/returnResponse', (ctx) => Response('5'))
        ..post('/', (ctx) => 'Post')
        ..put('/', (ctx) => 'Put')
        ..delete('/', (ctx) => 'Delete')
        ..getJson('/json', (ctx) => {'method': 'get'})
        ..postJson('/json', (ctx) => {'method': 'post'})
        ..putJson('/json', (ctx) => {'method': 'put'})
        ..deleteJson('/json', (ctx) => {'method': 'delete'});
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('GET.SetResponse', () async {
      await resty
          .get('http://localhost:10000/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
    });

    test('GET.ReturnValue', () async {
      await resty.get('http://localhost:10000/returnValue').exact(
          statusCode: 200, mimeType: 'text/plain', body: 'Hello world, Champ!');
    });

    test('GET.ReturnResponse', () async {
      await resty
          .get('http://localhost:10000/returnResponse')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '5');
    });

    test('Post', () async {
      await resty
          .post('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Post');
    });

    test('Put', () async {
      await resty
          .put('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Put');
    });

    test('Delete', () async {
      await resty
          .delete('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Delete');
    });

    test('GetJson', () async {
      await resty.get('http://localhost:10000/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"get"}');
    });

    test('PostJson', () async {
      await resty.post('http://localhost:10000/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"post"}');
    });

    test('PutJson', () async {
      await resty.put('http://localhost:10000/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"put"}');
    });

    test('DeleteJson', () async {
      await resty.delete('http://localhost:10000/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"delete"}');
    });
  });
}
