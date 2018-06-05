import 'package:http/http.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:collection/collection.dart';

main() {
  resty.globalClient = new http.IOClient();

  group("Session", () {
    final jar = new resty.CookieJar();

    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000)
        ..getJson('/api/add/:item', (ctx) async {
          final Session session = await ctx.session;
          final String newItem = ctx.pathParams['item'];

          final List<String> items = (session['items'] ?? '').split(',');

          // Add item to shopping cart stored on session
          if (!items.contains(newItem)) {
            items.add(newItem);
            session['items'] = items.join(',');
            return {"Action": "Added"};
          }

          return {"Action": "Already present"};
        })
        ..getJson('/api/remove/:item', (ctx) async {
          final Session session = await ctx.session;
          final String newItem = ctx.pathParams['item'];

          final List<String> items = (session['items'] ?? '').split(',');

          // Remove item from shopping cart stored on session
          if (items.contains(newItem)) {
            items.remove(newItem);
            session['items'] = items.join(',');
            return {"Action": "Removed"};
          }

          return {"Action": "Not present"};
        });
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('ParseNUpdate', () async {
      await resty
          .get('http://localhost:10000/api/add/Dog')
          .interceptBefore(jar.intercept)
          .go()
          .json<Map>()
          .expect([
        resty.bodyIs({"Action": "Added"}, const MapEquality().equals)
      ]);
      await resty
          .get('http://localhost:10000/api/add/Cat')
          .interceptBefore(jar.intercept)
          .go()
          .json<Map>()
          .expect([
        resty.bodyIs({"Action": "Added"}, const MapEquality().equals)
      ]);
      await resty
          .get('http://localhost:10000/api/add/Mink')
          .interceptBefore(jar.intercept)
          .go()
          .json<Map>()
          .expect([
        resty.bodyIs({"Action": "Added"}, const MapEquality().equals)
      ]);
      await resty
          .get('http://localhost:10000/api/remove/Cat')
          .interceptBefore(jar.intercept)
          .go()
          .json<Map>()
          .expect([
        resty.bodyIs({"Action": "Removed"}, const MapEquality().equals)
      ]);
      await resty
          .get('http://localhost:10000/api/remove/Cat')
          .interceptBefore(jar.intercept)
          .go()
          .json<Map>()
          .expect([
        resty.bodyIs({"Action": "Not present"}, const MapEquality().equals)
      ]);
    });
  });
}
