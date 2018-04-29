// library apis.book;

import 'package:jaguar/jaguar.dart';

@Controller(path: '/api/book', isRoot: true)
class BookRoutes {
  @Get()
  String get(Context ctx) => 'book';
}
