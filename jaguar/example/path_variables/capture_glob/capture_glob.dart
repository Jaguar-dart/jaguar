library example.routes;

import 'package:jaguar/jaguar.dart';

main(List<String> args) async {
  final server = new Jaguar();
  server.get(
      '/api/1/:path*',
      (ctx) => new Response('Deprecated! Use /api/2/${ctx.pathParams['path']}',
          statusCode: 500));
  await server.serve();
}
