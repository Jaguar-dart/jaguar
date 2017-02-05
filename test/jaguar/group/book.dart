library test.jaguar.group.normal.book;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

part 'book.g.dart';

@RouteGroup()
class BookApi {
  @Route(methods: const <String>['GET'])
  String getBook() => 'Get book';

  @Route(path: '/some/:param1', methods: const <String>['POST'])
  String some(String param1) => 'Some $param1';
}
