library example.basic_auth.server;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_auth_mongo/jaguar_auth_mongo.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';

import 'model/model.dart';

final Map<String, Book> _books = {
  '0': new Book.make('0', 'Book0', 'Author0'),
  '1': new Book.make('1', 'Book1', 'Author1'),
  '2': new Book.make('2', 'Book2', 'Author2'),
};

// Mongo pool
final mongoPool = MongoPool('mongodb://localhost:27017/test');

/// Interceptor creator to connect to MongoDb
Future<void> mongoInterceptor(Context ctx) => mongoPool.injectInterceptor(ctx);

/// This route group contains login and logout routes
@Controller(path: '/auth')
@Intercept([mongoInterceptor])
class AuthRoutes {
  @Post(path: '/login')
  Future login(Context ctx) async {
    await BasicAuth.authenticate<User>(ctx);
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    await Authorizer.authorize<User>(ctx);
    // Clear session
    (await ctx.session).clear();
  }
}

/// Collection of routes students can also access
@Controller(path: '/book')
@Intercept([mongoInterceptor, Authorizer<User>()])
class StudentRoutes {
  @Get(path: '/all')
  Response<String> getAllBooks(Context ctx) {
    List<Map> ret =
        _books.values.map((Book book) => bookSerializer.toMap(book)).toList();
    return Response.json(ret);
  }
}

@Controller(path: '/api')
class LibraryApi {
  @IncludeHandler()
  final auth = AuthRoutes();

  @IncludeHandler()
  final student = StudentRoutes();
}

main() async {
  final server = new Jaguar(port: 10000);
  server.userFetchers[User] = MgoUserManager<User>(userMgoSerializer);
  server.add(reflect(LibraryApi()));
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
