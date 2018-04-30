library jaguar.example.routes;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@Controller()
class ExampleController {
  @Get()
  String get(Context ctx) => 'Get';

  @Post()
  String post(_) => 'Post';

  @Put()
  String put(_) => 'Put';

  @Delete()
  String delete(_) => 'Delete';
}

main() async {
  Jaguar server = new Jaguar(port: 10000);
  server.add(reflect(new ExampleController()));
  await server.serve();
}