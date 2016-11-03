library test.jaguar.group.normal.book;

import 'package:jaguar/jaguar.dart';

class BookApi {
  @Route('', methods: const <String>['GET'])
  String getBook() => 'Get book';

  @Route('/some/:param1', methods: const <String>['POST'])
  String some(String param1) => 'Some $param1';
}
