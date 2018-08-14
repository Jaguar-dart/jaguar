import 'package:path_tree/path_tree.dart';

main() {
  final tree = PathTree<int>();

  // Add routes
  tree.addPath('/', 0);
  tree.addPath('/api', 1);
  tree.addPath('/api/book/create', 11);
  tree.addPath('/api/book/:id', 12);
  tree.addPath('/api/book/:id/edit', 13);
  tree.addPath('/api/book/:id/*', 14);
  tree.addPath('/api/user/create', 21);
  tree.addPath('/api/user/:id', 22);
  tree.addPath('/api/user/:id/edit', 23);
  tree.addPath('/api/user/:id/street/:street', 24);

  // Match routes
  print(tree.match(pathToSegments('/'), 'GET'));
  print(tree.match(pathToSegments('api'), 'GET'));
  print(tree.match(pathToSegments('api/book/create'), 'GET'));
  print(tree.match(pathToSegments('api/book/123'), 'GET'));
  print(tree.match(pathToSegments('api/book/123/edit'), 'GET'));
  print(tree.match(pathToSegments('api/book/123/author/123'), 'GET'));
  print(tree.match(pathToSegments('api/user/create'), 'GET'));
  print(tree.match(pathToSegments('api/user/123'), 'GET'));
  print(tree.match(pathToSegments('api/user/123/edit'), 'GET'));
  print(tree.match(pathToSegments('api/user/123/street/123'), 'GET'));
}
