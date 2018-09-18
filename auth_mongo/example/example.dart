library example.basic_auth.server;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_auth_mongo/jaguar_auth_mongo.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';
import 'package:jaguar_example_session_models/jaguar_example_session_models.dart';
import 'model/model.dart';

// Mongo pool
final mongoPool = MongoPool('mongodb://localhost:27018/test');

/// This route group contains login and logout routes
@GenController(path: '/auth')
class AuthRoutes extends Controller {
  @Post(path: '/login')
  Future<String> login(Context ctx) async {
    await BasicAuth.authenticate<User>(ctx);
    return "Success";
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    await Authorizer.authorize<User>(ctx);
    // Clear session
    (await ctx.session).clear();
  }

  @override
  Future<void> before(Context ctx) async {
    await mongoPool(ctx);
  }
}

/// Collection of routes students can also access
@GenController(path: '/books')
class StudentRoutes extends Controller {
  @GetJson()
  List<Book> getAllBooks(Context ctx) => books.values.toList();

  @override
  Future<void> before(Context ctx) async {
    await mongoPool(ctx);
    await Authorizer.authorize<User>(ctx);
  }
}

@GenController(path: '/api')
class LibraryApi extends Controller {
  @IncludeController()
  final auth = AuthRoutes();

  @IncludeController()
  final student = StudentRoutes();
}

main() async {
  final server = Jaguar(port: 10000);
  server.userFetchers[User] = MgoUserManager<User>(userMgoSerializer);
  server.add(reflect(LibraryApi()));
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
