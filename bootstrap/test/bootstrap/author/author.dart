library bootstrap.gen;

import 'package:dice/dice.dart';

import 'package:jaguar/jaguar.dart';

@injectable
@Controller(path: '/api/author', isRoot: true)
class AuthorRoutes {
  final String name;

  AuthorRoutes(@inject @Named('author-name') this.name);

  @Get()
  String get(Context ctx) => 'author $name';
}
