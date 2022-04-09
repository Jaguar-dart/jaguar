library test.jaguar.data.body.json;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

class InputModel {
  InputModel(this.input1, this.input2);

  final int input1;

  final int input2;

  int add() => input1 + input2;

  int sub() => input1 - input2;

  static InputModel fromJson(Map<dynamic, dynamic> map) =>
      InputModel(map['input1'], map['input2']);

  Map toJson() => {
        'input1': input1,
        'input2': input2,
      };
}

void main() {
  resty.globalClient = http.IOClient();

  group('data.body.json', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..post('/one/map', (ctx) async {
          final Map body = await ctx.bodyAsJsonMap();
          final InputModel input = InputModel.fromJson(body);
          return input.add();
        })
        ..post('/one/convert', (ctx) async {
          final InputModel input =
              await ctx.bodyAsJson(convert: InputModel.fromJson);
          return input.sub();
        })
        ..post('/many/list', (ctx) async {
          final List<Map<String, dynamic>>? body = await ctx.bodyAsJsonList();
          return body!.map(InputModel.fromJson).map((m) => m.add()).toString();
        })
        ..post('/many/convert', (ctx) async {
          final List<InputModel>? inputs =
              await ctx.bodyAsJsonList(convert: (InputModel.fromJson));
          return inputs!.map((m) => m.sub()).toString();
        })
        ..put('/primitive', (ctx) async {
          final num body = await ctx.bodyAsJson();
          return body * 2;
        });
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test(
        'One.Map',
        () => resty
            .post('http://localhost:$port/one/map')
            .json(InputModel(5, 15))
            .exact(statusCode: 200, body: '20', mimeType: 'text/plain'));

    test(
        'One.Convert',
        () => resty
            .post('http://localhost:$port/one/convert')
            .json(InputModel(30, 5))
            .exact(statusCode: 200, body: '25', mimeType: 'text/plain'));

    test(
        'Many.List',
        () => resty
            .post('http://localhost:$port/many/list')
            .json([InputModel(5, 15), InputModel(50, 55)]).exact(
                statusCode: 200, body: '(20, 105)', mimeType: 'text/plain'));

    test(
        'Many.Convert',
        () => resty
            .post('http://localhost:$port/many/convert')
            .json([InputModel(30, 5), InputModel(75, 20)]).exact(
                statusCode: 200, body: '(25, 55)', mimeType: 'text/plain'));

    test(
        'primitive',
        () => resty
            .put('http://localhost:$port/primitive')
            .body('4')
            .exact(statusCode: 200, body: '8', mimeType: 'text/plain'));
  });
}
