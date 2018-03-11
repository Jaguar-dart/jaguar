library test.jaguar.decode_body.json;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_reflect/jaguar_reflect.dart';

part 'json.g.dart';

class AddInput {
  AddInput(this.input1, this.input2);

  final int input1;

  final int input2;

  int add() => input1 + input2;

  static AddInput fromJson(Map<String, dynamic> map) =>
      new AddInput(map['input1'], map['input2']);

  Map toJson() => {
        'input1': input1,
        'input2': input2,
      };
}

@Api(path: '/api/add')
class JsonDecode extends _$JaguarJsonDecode {
  @Post(path: '/one')
  Future<int> addOne(Context ctx) async {
    final Map body = await ctx.req.bodyAsJsonMap();
    final AddInput input = AddInput.fromJson(body);
    return input.add();
  }

  @PostJson(path: '/many')
  Future<List<int>> addMany(Context ctx) async {
    final List<AddInput> inputs =
        await ctx.req.bodyAsJsonList(convert: (AddInput.fromJson));
    return inputs.map((AddInput input) => input.add()).toList();
  }

  @Post(path: '/doubled')
  Future<num> doubled(Context ctx) async {
    final num body = await ctx.req.bodyAsJson();
    return body * 2;
  }
}

void main() {
  group('Decode Json', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(reflect(new JsonDecode()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Decode Map', () async {
      await resty
          .post('/api/add/one')
          .authority('http://localhost:8000')
          .json(new AddInput(5, 15))
          .exact(statusCode: 200, body: '20', mimeType: 'text/plain');
    });

    test('Decode List', () async {
      await resty
          .post('/api/add/many')
          .authority('http://localhost:8000')
          .json([new AddInput(5, 15), new AddInput(50, 55)]).exact(
              statusCode: 200, body: '[20,105]', mimeType: MimeType.json);
    });

    test('Decode int', () async {
      await resty
          .post('/api/add/doubled')
          .authority('http://localhost:8000')
          .body('4')
          .exact(statusCode: 200, body: '8', mimeType: 'text/plain');
    });
  });
}
