import 'dart:collection';

class CountedSet<T> {
  final _set = SplayTreeMap<int, Set<T>>();

  final _values = Map<T, int>();

  CountedSet();

  Iterable<T> get values => _values.keys;

  int get length => _values.length;

  void add(int count, T value) {
    if (_values.containsKey(value)) throw Exception('Already present!');
    Set<T> set = _set[count] ??= Set<T>();
    _values[value] = count;
    set.add(value);
  }

  void remove(T value) {
    if (!_values.containsKey(value)) throw Exception('Not present!');
    int count = _values[value];

    Set<T> set = _set[count];
    if (set == null) {
      _values.remove(value);
      throw Exception('$value is not located at $count!');
    }

    if (!set.remove(value)) {
      _values.remove(value);
      throw Exception('$value is not located at $count!');
    }
    if (set.isEmpty) _set.remove(count);

    _values.remove(value);
  }

  void inc(T value) {
    int count = _values[value];
    if (count == null) throw Exception('$value is not present!');

    Set<T> set = _set[count];
    if (set == null) throw Exception('$value is not located at $count!');
    if (!set.remove(value)) throw Exception('$value is not located at $count!');
    if (set.isEmpty) _set.remove(count);

    count++;
    set = _set[count] ??= Set<T>();
    _values[value] = count;
    set.add(value);
  }

  void dec(T value) {
    int count = _values[value];
    if (count == null) throw Exception('$value is not present!');

    Set<T> set = _set[count];
    if (set == null) throw Exception('$value is not located at $count!');
    if (!set.remove(value)) throw Exception('$value is not located at $count!');
    if (set.isEmpty) _set.remove(count);

    count--;
    set = _set[count] ??= Set<T>();
    _values[value] = count;
    set.add(value);
  }

  T get leastUsed {
    if (_values.length == 0) return null;
    int firstKey = _set.firstKey();
    return _set[firstKey].first;
  }

  int numAt(int count) {
    Set<T> set = _set[count];
    if (set == null) return 0;
    return set.length;
  }

  List<T> removeAllAt(int count) {
    Set<T> set = _set[count];
    if (set == null) return [];

    for (T t in set) _values.remove(t);
    _set.remove(count);

    return set.toList();
  }

  bool contains(T value) => _values.containsKey(value);

  int countOf(T value) => _values[value];
}
