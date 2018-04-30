library test.jaguar.data.body.json;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:client_cookie/client_cookie.dart';

class InputModel {
  InputModel(this.input1, this.input2);

  final int input1;

  final int input2;

  int add() => input1 + input2;

  int sub() => input1 - input2;

  static InputModel fromJson(Map<String, dynamic> map) =>
      new InputModel(map['input1'], map['input2']);

  Map toJson() => {
        'input1': input1,
        'input2': input2,
      };
}

void main() {
  resty.globalClient = new http.IOClient();

  group('data.body.json', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
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
          final List<Map<String, dynamic>> body = await ctx.bodyAsJsonList();
          return body.map(InputModel.fromJson).map((m) => m.add()).toString();
        })
        ..post('/many/convert', (ctx) async {
          final List<InputModel> inputs =
              await ctx.bodyAsJsonList(convert: (InputModel.fromJson));
          return inputs.map((m) => m.sub()).toString();
        })
        ..put('/primitive', (ctx) async {
          final num body = await ctx.bodyAsJson();
          return body * 2;
        });
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'One.Map',
        () => resty
            .post('/one/map')
            .authority('http://localhost:10000')
            .json(new InputModel(5, 15))
            .exact(statusCode: 200, body: '20', mimeType: 'text/plain'));

    test(
        'One.Convert',
        () => resty
            .post('/one/convert')
            .authority('http://localhost:10000')
            .json(new InputModel(30, 5))
            .exact(statusCode: 200, body: '25', mimeType: 'text/plain'));

    test(
        'Many.List',
        () => resty
            .post('/many/list')
            .authority('http://localhost:10000')
            .json([new InputModel(5, 15), new InputModel(50, 55)]).exact(
                statusCode: 200, body: '(20, 105)', mimeType: 'text/plain'));

    test(
        'Many.Convert',
        () => resty
            .post('/many/convert')
            .authority('http://localhost:10000')
            .json([new InputModel(30, 5), new InputModel(75, 20)]).exact(
                statusCode: 200, body: '(25, 55)', mimeType: 'text/plain'));

    test(
        'primitive',
        () => resty
            .put('/primitive')
            .authority('http://localhost:10000')
            .body('4')
            .exact(statusCode: 200, body: '8', mimeType: 'text/plain'));
  });
}
