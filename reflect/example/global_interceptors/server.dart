library jaguar.example.routes;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@GenController(path: "/api")
class ExampleController extends Controller {
  @Get(path: "/get")
  String get(Context ctx) => 'Get';

  @override
  void before(Context ctx) {
    print("here");
  }
}

main() async {
  Jaguar server = Jaguar(port: 10000);
  server.add(reflect(ExampleController()));
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
