library test.jaguar.group.normal.book;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

part 'book.g.dart';

@Api()
class BookApi {
  @Route(methods: const <String>['GET'])
  String getBook(Context ctx) => 'Get book';

  @Route(path: '/some/:param1', methods: const <String>['POST'])
  String some(Context ctx) => 'Some ${ctx.pathParams.get('param1')}';
}
