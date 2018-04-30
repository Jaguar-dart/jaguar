library example.routes;

import 'package:jaguar/jaguar.dart';

main(List<String> args) async {
  final server = new Jaguar();
  server.get('/api/info', (_) => Response.json({'server': 'Jaguar'}));
  await server.serve();
}
