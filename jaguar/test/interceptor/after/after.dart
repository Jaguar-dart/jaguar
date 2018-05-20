library test.jaguar.intercept.after;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void bef(Context ctx) => ctx.addVariable(5);

void aft(Context ctx) =>
    ctx.response = new Response(ctx.getVariable<int>() * 5);

void aft1(Context ctx) => ctx.response = new StrResponse('aft1');

void bef2(Context ctx) {
  ctx.addVariable(5);
  ctx.after.add(aft2);
}

void aft2(Context ctx) => ctx.addVariable(ctx.getVariable<int>() * 2);

main() {
  resty.globalClient = new http.IOClient();

  group('After', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..get('/aft', (_) => null, after: [aft1])
        ..get('/befaft', (_) => null, before: [bef], after: [aft])
        ..get('/progaft', (_) => null, before: [bef2], after: [aft]);
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'After',
        () => resty
            .get('/aft')
            .authority('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'aft1'));

    test(
        'Before&After',
        () => resty
            .get('/befaft')
            .authority('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '25'));

    test(
        'ProgramaticAfter',
        () => resty
            .get('/progaft')
            .authority('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '50'));
  });
}
