library test.jaguar.route;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

void bef(Context ctx) {
  print('I ran before and injected 5!');
  ctx.addVariable(5);
}

void aft(Context ctx) {
  print('I ran after and read ${ctx.getVariable<int>()}');
}

void onExcept(Context ctx, e, s) {
  throw Response('excepted');
}

@Controller(path: '/api')
class ExampleController {
  @Get(path: '/intercepted')
  @Intercept(const [bef], after: const [aft])
  String intercepted(Context ctx) => 'Get';

  @Get(path: '/excepted')
  @OnException(const [onExcept])
  String excepted(Context ctx) => throw new Exception();
}

main() async {
  final jaguar = new Jaguar(port: 10000);
  jaguar.add(reflect(new ExampleController()));
  await jaguar.serve();
}
