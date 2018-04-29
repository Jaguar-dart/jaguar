library test.jaguar.intercept.after;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@Controller()
class ExampleController {
  @Get(path: '/hello')
  String hello(Context ctx) => 'Hello!';

  @Get(path: '/hello1')
  String hello1(Context ctx) => 'Hello1!';
}

main() {

}