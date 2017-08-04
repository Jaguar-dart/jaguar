library bootstrap.gen;

import 'dart:async';
import 'package:dice/dice.dart';

import 'package:jaguar/jaguar.dart';

part 'author.g.dart';

@injectable
@Api(path: '/api/author', isRoot: true)
class AuthorRoutes {
  final String name;

  AuthorRoutes(@inject @Named('author-name') this.name);

  @Get()
  String get(Context ctx) => 'author $name';
}
