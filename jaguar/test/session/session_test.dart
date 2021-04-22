library test.jaguar.session;

import 'package:http/io_client.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import '../ports.dart' as ports;

main() {
  resty.globalClient = http.IOClient();

  group("Session", () {
    final jar = resty.CookieJar();
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port, sessionManager: JaguarSessionManager())
        ..getJson('/api/add/:item', (ctx) async {
          final Session? session = await ctx.session;
          final String? newItem = ctx.pathParams['item'];

          final List<String> items = session!['items']?.split(',') ?? [];

          // Add item to shopping cart stored on session
          if (!items.contains(newItem)) {
            items.add(newItem!);
            session['items'] = items.join(',');
            return {"Action": "Added"};
          }

          return {"Action": "Already present"};
        })
        ..getJson('/api/remove/:item', (ctx) async {
          final Session? session = await ctx.session;
          final String? newItem = ctx.pathParams['item'];

          final List<String> items = (session!['items'] ?? '').split(',');

          // Remove item from shopping cart stored on session
          if (items.contains(newItem)) {
            items.remove(newItem);
            session['items'] = items.join(',');
            return {"Action": "Removed"};
          }

          return {"Action": "Not present"};
        });
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test('ParseNUpdate', () async {
      var resp = await resty
          .get('http://localhost:$port/api/add/Dog')
          .before(jar)
          .exact(statusCode: 200);
      expect(resp.json(), {"Action": "Added"});
      resp = await resty
          .get('http://localhost:$port/api/add/Cat')
          .before(jar)
          .exact(statusCode: 200);
      expect(resp.json(), {"Action": "Added"});
      resp = await resty
          .get('http://localhost:$port/api/add/Mink')
          .before(jar)
          .exact(statusCode: 200);
      expect(resp.json(), {"Action": "Added"});
      resp = await resty
          .get('http://localhost:$port/api/remove/Cat')
          .before(jar)
          .exact(statusCode: 200);
      expect(resp.json(), {"Action": "Removed"});
      resp = await resty
          .get('http://localhost:$port/api/remove/Cat')
          .before(jar)
          .exact(statusCode: 200);
      expect(resp.json(), {"Action": "Not present"});
    });
  });
}
