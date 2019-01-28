library test.jaguar.before;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@GenController(path: '/con')
class SubController extends Controller {
  @Get(path: '/get')
  String get(Context ctx) => 'Get ${ctx.getVariable(id: "sample")}';

  @override
  void before(Context ctx) {
    ctx.addVariable("Before", id: "sample");
  }
}

@GenController(path: "/api")
class ExampleController extends Controller {
  @IncludeController(path: '/sub')
  final SubController subController = new SubController();
}

void main() {
  resty.globalClient = new http.IOClient();

  group('Include', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: 10000);
      server.add(reflect(ExampleController()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'Get',
        () => resty.get('http://localhost:10000/api/sub/con/get').exact(
            statusCode: 200, mimeType: 'text/plain', body: 'Get Before'));
  });
}
