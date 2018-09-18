import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import 'package:jaguar_example_session_models/jaguar_example_session_models.dart';

final Map<String, Book> _books = {
  '0': new Book(id: '0', name: 'Book0'),
  '1': new Book(id: '1', name: 'Book1'),
};

/// This route group contains login and logout routes
@GenController()
class AuthRoutes extends Controller {
  @PostJson(path: '/login')
  Future<User> login(Context ctx) => FormAuth.authenticate<User>(ctx);

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }
}

@GenController(path: '/book')
class StudentRoutes extends Controller {
  @GetJson()
  List<Book> getAllBooks(Context ctx) => _books.values.toList();

  @GetJson(path: '/:id')
  Book getBook(Context ctx) {
    String id = ctx.pathParams.get('id');
    Book book = _books[id];
    return book;
  }

  @override
  Future<void> before(Context ctx) async {
    await Authorizer.authorize<User>(ctx);
  }
}

@GenController(path: '/api')
class LibraryApi extends Controller {
  @IncludeController()
  final auth = AuthRoutes();

  @IncludeController()
  final books = StudentRoutes();
}

server() async {
  final server = Jaguar(port: 10000)..add(reflect(LibraryApi()));
  server.userFetchers[User] = DummyUserFetcher(users);
  await server.serve();
}
