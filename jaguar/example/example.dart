import 'package:jaguar/jaguar.dart';

final server = new Jaguar()
  ..get('/', (ctx) => 'Get')
  ..postJson('/json', (ctx) => {'method': 'post'});

main() async {
  await server.serve();
}
