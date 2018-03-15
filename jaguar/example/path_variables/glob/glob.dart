library example.routes;

import 'package:jaguar/jaguar.dart';

main(List<String> args) async {
  final server = new Jaguar();
  server.get('/api/1/*', (_) => new Response('Deprecated!', statusCode: 500));
  await server.serve();
}
