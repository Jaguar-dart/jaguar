/// Splits given path to composing segments
Iterable<String> pathToSegments(final String path) {
  Iterable<String> segments = path.split(RegExp(r'/+'));
  if (segments.isEmpty) return segments;
  if (segments.first.isEmpty) segments = segments.skip(1);
  if (segments.isEmpty) return segments;
  if (segments.last.isEmpty) segments = segments.take(segments.length - 1);
  return segments;
}

Iterable<String> cleanupSegments(Iterable<String> segments) {
  final ret = <String>[];
  for (String seg in segments) {
    if (seg.isEmpty) continue;
    ret.add(seg);
  }
  return ret;
}

class SubTree<T> {
  final value = <String, T>{};

  final regexes = <MapEntry<RegExp, SubTree<T>>>[];

  final fixed = <String, SubTree<T>>{};

  SubTree<T> varSubTree;

  final globValue = <String, T>{};
}

class PathTree<T> {
  final _tree = SubTree<T>();

  void addPath(String path, T value,
      {Iterable<String> tags: const ['*'],
      Map<String, String> pathRegEx: const {}}) {
    final segs = pathToSegments(path);
    addPathAsSegments(segs, value, tags: tags, pathRegEx: pathRegEx);
  }

  void addPathAsSegments(Iterable<String> segments, T value,
      {Iterable<String> tags: const ['*'],
      Map<String, String> pathRegEx: const {}}) {
    SubTree<T> subtree = _tree;
    final int numSegs = segments.length;
    for (int i = 0; i < numSegs; i++) {
      String seg = segments.elementAt(i);
      if (i == numSegs - 1 &&
          (seg == '*' || (seg.startsWith(':') && seg.endsWith('*')))) {
        for (String tag in tags) {
          // TODO what if there is already a value here?
          subtree.globValue[tag] = value;
        }
        return;
      } else if (seg.startsWith(':')) {
        String name = seg.substring(1);
        if (!pathRegEx.containsKey(name)) {
          SubTree<T> next = subtree.varSubTree;
          if (next == null) {
            next = SubTree<T>();
            subtree.varSubTree = next;
          }
          subtree = next;
        } else {
          SubTree<T> next = SubTree<T>();
          subtree.regexes.add(MapEntry(RegExp(pathRegEx[name]), next));
          subtree = next;
        }
      } else {
        SubTree<T> next = subtree.fixed[seg];
        if (next == null) {
          next = SubTree<T>();
          subtree.fixed[seg] = next;
        }
        subtree = next;
      }
    }

    for (String tag in tags) {
      // TODO what if there is already a value here?
      subtree.value[tag] = value;
    }
  }

  T match(Iterable<String> segments, String tag) =>
      _match(_tree, segments, tag);

  T _match(SubTree<T> root, Iterable<String> segments, String tag) {
    if (segments.isEmpty) return root.value[tag] ?? root.value['*'];

    final int numSegs = segments.length;
    SubTree<T> subTree = root;
    for (int i = 0; i < numSegs; i++) {
      String seg = segments.elementAt(i);

      SubTree<T> next = subTree.fixed[seg];
      if (next == null) {
        for (MapEntry<RegExp, SubTree<T>> regex in subTree.regexes) {
          if (regex.key.allMatches(seg).isNotEmpty) {
            if (next != null) {
              T ret = _matchParts(subTree, segments.skip(i), tag);
              if (ret != null) return ret;
              break;
            }
            next = regex.value;
          }
        }
        if (next == null) {
          if (subTree.varSubTree != null) {
            if (subTree.globValue != null) {
              T ret = _match(subTree.varSubTree, segments.skip(i + 1), tag);
              if (ret != null) return ret;
              ret = subTree.globValue[tag] ?? subTree.globValue['*'];
              if (ret != null) return ret;
            }
            next = subTree.varSubTree;
          }
          if (next == null)
            return subTree.globValue[tag] ?? subTree.globValue['*'];
        }
      }
      subTree = next;
    }

    return subTree.value[tag] ?? subTree.value['*'];
  }

  T _matchParts(SubTree<T> root, Iterable<String> segments, String tag) {
    for (MapEntry<RegExp, SubTree<T>> regex in root.regexes) {
      if (regex.key.allMatches(segments.first).isNotEmpty) {
        T ret = _match(regex.value, segments.skip(1), tag);
        if (ret != null) return ret;
      }
    }
    return null;
  }
}
