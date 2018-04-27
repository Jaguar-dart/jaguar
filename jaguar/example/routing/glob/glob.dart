import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar();
  server.get('/api/v1/*', (_) => 'v1 API deprecated!');
  await server.serve();
}
