import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar(port: 10001);
  // Add a route handler for 'GET' method at path '/hello'
  server.get('/hello', (_) => 'Hello world!');
  await server.serve();
}
