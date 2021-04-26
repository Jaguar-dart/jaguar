library test.jaguar.route.mux;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('mux', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..get('/hello', (ctx) {
          ctx.response = Response(body: 'Hello world!');
        })
        ..get('/returnValue', (ctx) => 'Hello world, Champ!')
        ..get('/returnResponse', (ctx) => Response(body: '5'))
        ..post('/', (ctx) => 'Post')
        ..put('/', (ctx) => 'Put')
        ..delete('/', (ctx) => 'Delete')
        ..getJson('/json', (ctx) => {'method': 'get'})
        ..postJson('/json', (ctx) => {'method': 'post'})
        ..putJson('/json', (ctx) => {'method': 'put'})
        ..deleteJson('/json', (ctx) => {'method': 'delete'});
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test('GET.SetResponse', () async {
      await resty
          .get('http://localhost:$port/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
    });

    test('GET.ReturnValue', () async {
      await resty.get('http://localhost:$port/returnValue').exact(
          statusCode: 200, mimeType: 'text/plain', body: 'Hello world, Champ!');
    });

    test('GET.ReturnResponse', () async {
      await resty
          .get('http://localhost:$port/returnResponse')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '5');
    });

    test('Post', () async {
      await resty
          .post('http://localhost:$port')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Post');
    });

    test('Put', () async {
      await resty
          .put('http://localhost:$port')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Put');
    });

    test('Delete', () async {
      await resty
          .delete('http://localhost:$port')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Delete');
    });

    test('GetJson', () async {
      await resty.get('http://localhost:$port/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"get"}');
    });

    test('PostJson', () async {
      await resty.post('http://localhost:$port/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"post"}');
    });

    test('PutJson', () async {
      await resty.put('http://localhost:$port/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"put"}');
    });

    test('DeleteJson', () async {
      await resty.delete('http://localhost:$port/json').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"delete"}');
    });
  });
}
