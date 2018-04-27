import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar();
  server.get('/api/user/:/setting', (ctx) => 'Invoked path ${ctx.uri.path}!');
  await server.serve();
}
