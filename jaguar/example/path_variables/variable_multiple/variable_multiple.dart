library example.routes;

import 'package:jaguar/jaguar.dart';

main(List<String> args) async {
  final server = new Jaguar();
  server.get('/api/addition/:a/:b', (ctx) {
    final int a = int.parse(ctx.pathParams['a']);
    final int b = int.parse(ctx.pathParams['b']);
    return a + b;
  });
  await server.serve();
}
