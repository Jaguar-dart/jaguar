library jaguar_mongo.example;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:jaguar_mongo/jaguar_mongo.dart';

/// Mongo Pool
final mongoPool = MongoPool('mongodb://localhost:27018/test');

@Controller(path: '/contact')
class ContactApi {
  @GetJson()
  Future<List> readAll(Context ctx) async {
    Db db = await mongoPool.injectInterceptor(ctx); // Get [Db]
    // Use Db to fetch items
    return await (await db.collection('contact').find()).toList();
  }

  @PostJson()
  Future<List> add(Context ctx) async {
    Map body = await ctx.bodyAsJsonMap();
    Db db = await mongoPool.injectInterceptor(ctx);
    await db.collection('contact').insert(body);
    return await (await db.collection('contact').find()).toList();
  }
}

main(List<String> args) async {
  final server = Jaguar(port: 10000);
  server.add(reflect(ContactApi()));
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
