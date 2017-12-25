import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar(); // Serves the API at localhost:8080 by default
  // Add a route handler for 'GET' method at path '/hello'
  server.get('/hello', (Context ctx) => 'Hello world!');
  await server.serve();
}
