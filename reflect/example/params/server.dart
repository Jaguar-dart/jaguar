library jaguar.example.routes;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@Controller(path: '/api')
class ExampleController {
  @Get(path: '/query')
  String query(Context ctx) => ctx.query['msg'];

  @Get(path: '/path/:id')
  String path(Context ctx) => ctx.pathParams['id'];
}

main() async {
  Jaguar server = new Jaguar(port: 10000);
  server.add(reflect(new ExampleController()));
  await server.serve();
}
