import 'package:path_tree/path_tree.dart';

main() {
  final tree = PathTree<int>();

  // Add routes
  tree.addPath('/*', 0);
  tree.addPath('/api', 1);

  // Match routes
  print(tree.match(pathToSegments('/'), 'GET'));
}
