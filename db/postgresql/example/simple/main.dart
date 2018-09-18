/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:postgresql/postgresql.dart';

import 'package:jaguar_postgresql/jaguar_postgresql.dart';

@Api(path: '/api')
class PostgreExampleApi {
  @Get(path: '/post')
  // NOTE: This is how Postgre interceptor is wrapped
  // around a route.
  @WrapOne(#postgresDb)
  Future<Response<String>> mongoTest(Context ctx) async {
    // NOTE: This is how the opened postgre connection is injected
    // into routes
    Connection db = ctx.getInput(PostgresDb);
    await db.execute("delete FROM posts");
    await db.execute("insert into posts values (1, 'holla', 'jon')");
    Row row =
        (await db.query("select * from posts WHERE _id = 1").toList()).first;
    return Response.json(row.toMap());
  }

  PostgresDb postgresDb(Context ctx) =>
      new PostgresDb('postgres://postgres:dart_jaguar@localhost/postgres');
}

Future<Null> main(List<String> args) async {
  final server = new Jaguar(multiThread: false);
  server.addApiReflected(new PostgreExampleApi());

  await server.serve();
}
