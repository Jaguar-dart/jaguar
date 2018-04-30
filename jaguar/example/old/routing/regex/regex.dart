import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar();
  server.get('/api/user/:id/setting',
      (ctx) => 'Settings requested for user ${ctx.pathParams['id']}!',
      pathRegEx: {'id': r'^[0-9]{1,3}$'});
  await server.serve();
}
