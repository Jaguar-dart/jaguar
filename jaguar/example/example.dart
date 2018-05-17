import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar(port: 10000);
  server
    ..get('/', (ctx) => 'Get')
    ..post('/', (ctx) => 'Post')
    ..getJson('/json', (ctx) => {'method': 'get'})
    ..postJson('/json', (ctx) => {'method': 'post'})
    ..get('/hello', (ctx) {
      ctx.response = new StrResponse('Hello world!');
    });
  await server.serve();
}
