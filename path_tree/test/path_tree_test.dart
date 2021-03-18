import 'package:path_tree/path_tree.dart';
import 'package:test/test.dart';

void main() {
  group('Smoke', () {
    test('First Test', () {
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
      expect(tree.match(pathToSegments('/'), 'GET'), 0);
      expect(tree.match(pathToSegments('api'), 'GET'), 1);
      expect(tree.match(pathToSegments('api/book/create'), 'GET'), 11);
      expect(tree.match(pathToSegments('api/book/123'), 'GET'), 12);
      expect(tree.match(pathToSegments('api/book/123/edit'), 'GET'), 13);
      expect(tree.match(pathToSegments('api/book/123/author/123'), 'GET'), 14);
      expect(tree.match(pathToSegments('api/user/create'), 'GET'), 21);
      expect(tree.match(pathToSegments('api/user/123'), 'GET'), 22);
      expect(tree.match(pathToSegments('api/user/123/edit'), 'GET'), 23);
      expect(tree.match(pathToSegments('api/user/123/street/123'), 'GET'), 24);
    });
  });
}
