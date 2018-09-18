/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar/jaguar.dart';
import 'package:postgres/postgres.dart' as pg;

import 'package:conn_pool/conn_pool.dart';
import 'package:jaguar_postgres/jaguar_postgres.dart';

final postgresPool = PostgresPool('jaguar_learn',
    password: 'dart_jaguar', minPoolSize: 5, maxPoolSize: 10);

@GenController(path: '/contact')
class ContactsApi extends Controller {
  @GetJson()
  Future<List<Map>> readAll(Context ctx) async {
    pg.PostgreSQLConnection db = await postgresPool(ctx);
    List<Map<String, Map<String, dynamic>>> values =
        await db.mappedResultsQuery("SELECT * FROM contacts;");
    return values.map((m) => m.values.first).toList();
  }

  @PostJson()
  Future<List<Map>> create(Context ctx) async {
    Map body = await ctx.bodyAsJsonMap();
    pg.PostgreSQLConnection db = await postgresPool(ctx);
    List<List<dynamic>> id = await db.query(
        "INSERT INTO contacts (name, age) VALUES ('${body['name']}', ${body['age']}) RETURNING id;");
    if (id.isEmpty || id.first.isEmpty) Response.json(null);
    List<Map<String, Map<String, dynamic>>> values =
        await db.mappedResultsQuery("SELECT * FROM contacts;");
    return values.map((m) => m.values.first).toList();
  }
}

Future<void> setup() async {
  // TODO handle open error
  Connection<pg.PostgreSQLConnection> conn = await postgresPool.pool.get();
  pg.PostgreSQLConnection db = conn.connection;

  try {
    await db.execute("CREATE DATABSE jaguar_learn;");
  } catch (e) {} finally {}

  try {
    await db.execute("DROP TABLE contacts;");
  } catch (e) {} finally {}

  try {
    await db.execute(
        "CREATE TABLE contacts (id SERIAL PRIMARY KEY, name VARCHAR(255), age INT);");
  } catch (e) {} finally {
    if (conn != null) await conn.release();
  }
}

Future<void> main() async {
  await setup();

  final server = Jaguar(port: 10000);
  server.add(reflect(ContactsApi()));
  server.log.onRecord.listen(print);

  await server.serve(logRequests: true);
}
