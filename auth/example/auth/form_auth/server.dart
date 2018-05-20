library example.basic_auth.server;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import '../../model/model.dart';
import '../../model/auth_model_manager.dart';

final Map<String, Book> _books = {
  '0': new Book(id: '0', name: 'Book0'),
  '1': new Book(id: '1', name: 'Book1'),
};

/// This route group contains login and logout routes
@Controller()
class AuthRoutes {
  @PostJson(path: '/login')
  @Intercept(const [const FormAuth(WhiteListUserFetcher.userFetcher)])
  User login(Context ctx) => ctx.getVariable<User>();

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }
}

@Controller(path: '/book')
@Intercept(const [const Authorizer(WhiteListUserFetcher.userFetcher)])
class StudentRoutes {
  @GetJson()
  List<Book> getAllBooks(Context ctx) => _books.values.toList();

  @GetJson(path: '/:id')
  Book getBook(Context ctx) {
    String id = ctx.pathParams.get('id');
    Book book = _books[id];
    return book;
  }
}

@Controller(path: '/api')
class LibraryApi {
  @IncludeHandler()
  final auth = new AuthRoutes();

  @IncludeHandler()
  final books = new StudentRoutes();
}

server() async {
  final server = new Jaguar(port: 10000)..add(reflect(new LibraryApi()));
  await server.serve();
}
