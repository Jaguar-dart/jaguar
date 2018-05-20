library example.basic_auth.server;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_auth_mongo/jaguar_auth_mongo.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';

import '../../model/model.dart';

final Map<String, Book> _books = {
  '0': new Book.make('0', 'Book0', 'Author0'),
  '1': new Book.make('1', 'Book1', 'Author1'),
  '2': new Book.make('2', 'Book2', 'Author2'),
};

final MgoUserManager<User> modelManager =
    new MgoUserManager<User>(userMgoSerializer);

/// Interceptor creator for authorization
Authorizer authorizer(Context ctx) => new Authorizer(modelManager);

/// Interceptor creator to connect to MongoDb
MongoDb mongoDb(Context ctx) => new MongoDb('mongodb://localhost:27017/test');

/// This route group contains login and logout routes
@Api(path: '/auth')
@WrapOne(mongoDb)
class AuthRoutes {
  @Post(path: '/login')
  Future login(Context ctx) async {
    await BasicAuth.authenticate(ctx, modelManager);
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session
    (await ctx.session).clear();
  }
}

/// Collection of routes students can also access
@Api(path: '/book')
@Wrap(const [mongoDb, authorizer])
class StudentRoutes {
  @Get(path: '/all')
  Response<String> getAllBooks(Context ctx) {
    List<Map> ret =
        _books.values.map((Book book) => bookSerializer.toMap(book)).toList();
    return Response.json(ret);
  }
}

@Api(path: '/api')
class LibraryApi {
  @IncludeApi()
  final AuthRoutes auth = new AuthRoutes();

  @IncludeApi()
  final StudentRoutes student = new StudentRoutes();
}

server() async {
  final jaguar = new Jaguar(port: 10000);
  jaguar.addApi(reflect(new LibraryApi()));
  await jaguar.serve();
}
