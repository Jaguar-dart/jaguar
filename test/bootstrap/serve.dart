import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_client/jaguar_client.dart';

import 'package:dice/dice.dart';

import 'package:jaguar_client/testing.dart';

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
    final client = new JsonClient(new http.Client());

    setUpAll(() async {
      final injector = new Injector.fromModules([new MyModule()]);
      server = new Jaguar(port: 8000);
      bootstrap(server, injector: injector);
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Api from same library', () async {
      final JsonResponse resp =
          await client.get('http://localhost:8000/api/main');
      expect(resp, hasStatus(200));
      expect(resp, hasBodyStr('main'));
    });

    test('Api from different library', () async {
      final JsonResponse resp =
          await client.get('http://localhost:8000/api/author');
      expect(resp, hasStatus(200));
      expect(resp, hasBodyStr('author Dan Brown'));
    });

    test('Api from another different library', () async {
      final JsonResponse resp =
          await client.get('http://localhost:8000/api/book');
      expect(resp, hasStatus(200));
      expect(resp, hasBodyStr('book'));
    });
  });
}
