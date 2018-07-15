library example.basic_auth.server;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import 'package:jaguar_example_session_models/jaguar_example_session_models.dart';

main() async {
  final server = Jaguar(port: 10000);
  // Register user fetcher
  server.userFetchers[User] = DummyUserFetcher(users);
  server.postJson(
    '/login',
    // Authentication
    (Context ctx) async => await BasicAuth.authenticate<User>(ctx),
  );
  server.getJson(
    '/books',
    (Context ctx) => books.values.toList(),
    before: [Authorizer<User>()], // Authorization
  );
  await server.serve();
}
