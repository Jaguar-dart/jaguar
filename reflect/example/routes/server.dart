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

  @GetJson(path: '/json')
  Map getJson(_) => {'method': 'get'};

  @PostJson(path: '/json')
  Map postJson(_) => {'method': 'post'};

  @PutJson(path: '/json')
  Map putJson(_) => {'method': 'put'};

  @DeleteJson(path: '/json')
  Map deleteJson(_) => {'method': 'delete'};

  @HttpMethod(path: '/setResponse', methods: const <String>['GET'])
  void hello(Context ctx) => ctx.response = new StrResponse('Hello world!');

  @Get(path: '/returnResponse')
  Response<int> returnResponse(Context ctx) => new Response(5);
}

main() async {
  Jaguar server = new Jaguar(port: 10000);
  server.add(reflect(new ExampleController()));
  await server.serve();
}