library test.jaguar.intercept.after;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../../ports.dart' as ports;

void bef(Context ctx) => ctx.addVariable(5);

void aft(Context ctx) => ctx.response = Response(ctx.getVariable<int>()! * 5);

void aft1(Context ctx) => ctx.response = Response('aft1');

void bef2(Context ctx) {
  ctx.addVariable(5);
  ctx.after.add(aft2);
}

void aft2(Context ctx) => ctx.addVariable(ctx.getVariable<int>()! * 2);

main() {
  resty.globalClient = http.IOClient();

  group('After', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..get('/aft', (_) => null, after: [aft1])
        ..get('/befaft', (_) => null, before: [bef], after: [aft])
        ..get('/progaft', (_) => null, before: [bef2], after: [aft]);
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test(
        'After',
        () => resty
            .get('http://localhost:$port/aft')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'aft1'));

    test(
        'Before&After',
        () => resty
            .get('http://localhost:$port/befaft')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '25'));

    test(
        'ProgramaticAfter',
        () => resty
            .get('http://localhost:$port/progaft')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '50'));
  });
}
