library jaguar.example.routes;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@GenController()
class ExampleController extends Controller {
  @Get()
  String get(Context ctx) => 'Get';

  @Post()
  String post(_) => 'Post';

  @Put()
  String put(_) => 'Put';

  @Delete()
  String delete(_) => 'Delete';

  @override
  void before(Context ctx) {
    print("here");
  }
}

main() async {
  Jaguar server = new Jaguar(port: 10000);
  server.add(reflect(new ExampleController()));
  await server.serve();
}
