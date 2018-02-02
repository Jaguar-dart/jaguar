library example.body.json;

import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

dynamic x(dynamic ctx) => new Response(null);

Future<dynamic> x1(dynamic ctx) async => new Response(null);

String x2(dynamic ctx) => '';

Future<String> x3(dynamic ctx) async => '';

Response x4(dynamic ctx) => null;

Future<Response> x5(dynamic ctx) async => null;

main() {
  test('simpleHandler.retType', () {
    expect(simpleHandler(null, null, x), new isInstanceOf<SimpleRouteChain>());
    expect(simpleHandler(null, null, x1), new isInstanceOf<SimpleRouteChain>());
    expect(simpleHandler(null, null, (Context c) => new Response(null)),
        new isInstanceOf<SimpleRouteChain>());

    expect(simpleHandler(null, null, x2), new isInstanceOf<RetResultHandler>());
    expect(simpleHandler(null, null, x3),
        new isInstanceOf<RetResultAsyncHandler>());
    expect(
        simpleHandler(null, null, x4), new isInstanceOf<RetResponseHandler>());
    expect(simpleHandler(null, null, x5),
        new isInstanceOf<RetResponseAsyncHandler>());
  });
}
