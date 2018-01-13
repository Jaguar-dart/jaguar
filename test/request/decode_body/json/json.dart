library test.jaguar.decode_body.json;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'json.g.dart';

class AddInput {
  AddInput(this.input1, this.input2);

  final int input1;

  final int input2;

  int add() => input1 + input2;

  static AddInput fromJson(Map<String, dynamic> map) =>
      new AddInput(map['input1'], map['input2']);

  static List<AddInput> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map((Map<String, dynamic> map) => fromJson(map)).toList();
}

@Api(path: '/api/add')
class JsonDecode extends _$JaguarJsonDecode {
  @Post(path: '/one')
  Future<String> addOne(Context ctx) async {
    final Map body = await ctx.req.bodyAsJsonMap();
    final AddInput input = AddInput.fromJson(body);
    return input.add().toString();
  }

  @Post(path: '/many')
  Future<String> addMany(Context ctx) async {
    final List body = await ctx.req.bodyAsJsonList();
    final List<AddInput> inputs = AddInput.fromJsonList(body);
    return '[' +
        inputs.map((AddInput input) => input.add().toString()).join(',') +
        ']';
  }

  @Post(path: '/doubled')
  Future<String> doubled(Context ctx) async {
    final num body = await ctx.req.bodyAsJson();
    return (body * 2).toString();
  }
}

void main() {
  group('Decode Json', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new JsonDecode());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Decode Map', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/add/one');
      http.Response response =
          await http.post(uri, body: '{"input1": 5, "input2": 15}');

      expect(response.statusCode, 200);
      expect(response.body, "20");
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'text/plain; charset=utf-8');
    });

    test('Decode List', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/add/many');
      http.Response response = await http.post(uri,
          body: '[{"input1": 5, "input2": 15}, {"input1": 50, "input2": 55}]');

      expect(response.statusCode, 200);
      expect(response.body, "[20,105]");
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'text/plain; charset=utf-8');
    });

    test('Decode int', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/add/doubled');
      http.Response response = await http.post(uri, body: '4');

      expect(response.statusCode, 200);
      expect(response.body, "8");
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'text/plain; charset=utf-8');
    });
  });
}
