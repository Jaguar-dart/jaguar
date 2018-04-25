import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import 'package:dice/dice.dart';

// ignore: unused_import
import 'author/author.dart';
// ignore: unused_import
import 'book/book.dart';

@Api(path: '/api/main', isRoot: true)
class MainRoutes {
  @Get()
  String get(Context ctx) => 'main';
}

class MyModule extends Module {
  configure() {
    register(String, named: 'author-name').toInstance('Dan Brown');
  }
}

main() async {
  group('bootstrap', () {
    Jaguar server;

    setUpAll(() async {
      final injector = new Injector.fromModules([new MyModule()]);
      server = new Jaguar(port: 8000);
      bootstrap(server, injector: injector);
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'Api from same library',
        () => resty
            .get('/api/main')
            .authority('http://localhost:8000')
            .exact(statusCode: 200, body: 'main'));

    test(
        'Api from different library',
        () => resty
            .get('/api/author')
            .authority('http://localhost:8000')
            .exact(statusCode: 200, body: 'author Dan Brown'));

    test(
        'Api from another different library',
        () => resty
            .get('/api/book')
            .authority('http://localhost:8000')
            .exact(statusCode: 200, body: 'book'));
  });
}
