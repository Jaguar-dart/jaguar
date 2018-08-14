class SubTree<T> {
  T value;

  final regexes = <MapEntry<RegExp, SubTree<T>>>[];

  final fixed = <String, SubTree<T>>{};

  SubTree<T> varSubTree;

  T globValue;
}

class PathTree<T> {
  final _tree = SubTree<T>();

  void addPath(String path, T value, Map<String, String> pathRegEx) {
    final segs = path.split('/').where((s) => s.isNotEmpty).toList();
    addPathAsSegments(segs, value, pathRegEx);
  }

  void addPathAsSegments(
      List<String> segments, T value, Map<String, String> pathRegEx) {
    SubTree<T> subtree = _tree;
    final int numSegs = segments.length;
    for (int i = 0; i < numSegs; i++) {
      String seg = segments[i];
      if (i == numSegs - 1 &&
          (seg == '*' || (seg.startsWith(':') && seg.endsWith('*')))) {
        // TODO what if there is already a value here?
        subtree.globValue = value;
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

    // TODO what if there is already a value here?
    subtree.value = value;
  }

  T match(Iterable<String> segments) => _match(_tree, segments);

  T _match(SubTree<T> root, Iterable<String> segments) {
    if (segments.isEmpty) return root.value;

    final int numSegs = segments.length;
    SubTree<T> subTree = root;
    for (int i = 0; i < numSegs; i++) {
      String seg = segments.elementAt(i);

      SubTree<T> next = subTree.fixed[seg];
      if (next == null) {
        for (MapEntry<RegExp, SubTree<T>> regex in subTree.regexes) {
          if (regex.key.allMatches(seg).isNotEmpty) {
            if (next != null) {
              T ret = _matchParts(subTree, segments.skip(i));
              if(ret != null) return ret;
              break;
            }
            next = regex.value;
          }
        }
        if (next == null) {
          if(subTree.varSubTree != null) {
            if(subTree.globValue != null) {
              T ret = _match(subTree.varSubTree, segments.skip(i + 1));
              if(ret != null) return ret;
              return subTree.globValue;
            }
            next = subTree.varSubTree;
          }
          if (next == null) return subTree.globValue;
        }
      }
      subTree = next;
    }

    return subTree.value;
  }

  T _matchParts(SubTree<T> root, Iterable<String> segments) {
    for (MapEntry<RegExp, SubTree<T>> regex in root.regexes) {
      if (regex.key.allMatches(segments.first).isNotEmpty) {
        T ret = _match(regex.value, segments.skip(1));
        if (ret != null) return ret;
      }
    }
    return null;
  }
}
