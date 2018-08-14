import 'package:path_tree/path_tree.dart';

main() {
  final tree = PathTree<int>();

  // Add routes
  tree.addPath('/', 0, {});
  tree.addPath('/api', 1, {});
  tree.addPath('/api/book/create', 11, {});
  tree.addPath('/api/book/:id', 12, {});
  tree.addPath('/api/book/:id/edit', 13, {});
  tree.addPath('/api/book/:id/*', 14, {});
  tree.addPath('/api/user/create', 21, {});
  tree.addPath('/api/user/:id', 22, {});
  tree.addPath('/api/user/:id/edit', 23, {});
  tree.addPath('/api/user/:id/street/:street', 24, {});

  // Match routes
  print(tree.match(''.split('/').where((s) => s.isNotEmpty)));
  print(tree.match('api'.split('/')));
  print(tree.match('api/book/create'.split('/')));
  print(tree.match('api/book/create'.split('/')));
  print(tree.match('api/book/123'.split('/')));
  print(tree.match('api/book/123/edit'.split('/')));
  print(tree.match('api/book/123/author/123'.split('/')));
  print(tree.match('api/user/create'.split('/')));
  print(tree.match('api/user/123'.split('/')));
  print(tree.match('api/user/123/edit'.split('/')));
  print(tree.match('api/user/123/street/123'.split('/')));
}
