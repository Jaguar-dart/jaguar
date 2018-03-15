library example.routes;

import 'package:jaguar/jaguar.dart';

main(List<String> args) async {
  final quotes = <String>[
    'But man is not made for defeat. A man can be destroyed but not defeated.',
    'When you reach the end of your rope, tie a knot in it and hang on.',
    'Learning never exhausts the mind.',
  ];

  final server = new Jaguar();
  server.get('/api/quote', (ctx) {
    final int index = ctx.query.getInt('index', 1);
    return quotes[index + 1];
  });
  await server.serve();
}
