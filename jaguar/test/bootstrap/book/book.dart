// library apis.book;

import 'package:jaguar/jaguar.dart';

@Api(path: '/api/book', isRoot: true)
class BookRoutes {
  @Get()
  String get(Context ctx) => 'book';
}
