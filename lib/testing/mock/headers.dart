part of jaguar.testing.mock;

/// Mock implementation of [HttpHeader] used to test Jaguar routes
class MockHttpHeaders implements HttpHeaders {
  /// Internal headers store
  final _headers = new HashMap<String, List<String>>();

  operator [](String key) => _headers[key];

  /// Returns value of 'content-length' header
  int get contentLength => int.parse(_headers[HttpHeaders.CONTENT_LENGTH][0]);

  /// Returns value of 'if-modified-since' header
  DateTime get ifModifiedSince {
    List<String> values = _headers[HttpHeaders.IF_MODIFIED_SINCE];
    if (values != null) {
      try {
        return HttpDate.parse(values[0]);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Sets 'if-modified-since' header
  void set ifModifiedSince(DateTime ifModifiedSince) {
    // Format "ifModifiedSince" header with date in Greenwich Mean Time (GMT).
    String formatted = HttpDate.format(ifModifiedSince.toUtc());
    _set(HttpHeaders.IF_MODIFIED_SINCE, formatted);
  }

  ContentType contentType;

  void set(String name, Object value) {
    name = name.toLowerCase();
    _headers.remove(name);
    _addAll(name, value);
  }

  String value(String name) {
    name = name.toLowerCase();
    List<String> values = _headers[name];
    if (values == null) return null;
    if (values.length > 1) {
      throw new HttpException("More than one value for header $name");
    }
    return values[0];
  }

  String toString() => '$runtimeType : $_headers';

  void add(String name, value) {
    _add(name, value);
  }

  // [name] must be a lower-case version of the name.
  void _add(String name, value) {
    if (name == HttpHeaders.IF_MODIFIED_SINCE) {
      if (value is DateTime) {
        ifModifiedSince = value;
      } else if (value is String) {
        _set(HttpHeaders.IF_MODIFIED_SINCE, value);
      } else {
        throw new HttpException("Unexpected type for header named $name");
      }
    } else {
      _addValue(name, value);
    }
  }

  void _addAll(String name, value) {
    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _add(name, value[i]);
      }
    } else {
      _add(name, value);
    }
  }

  void _addValue(String name, Object value) {
    List<String> values = _headers[name];
    if (values == null) {
      values = new List<String>();
      _headers[name] = values;
    }
    if (value is DateTime) {
      values.add(HttpDate.format(value));
    } else {
      values.add(value.toString());
    }
  }

  void _set(String name, String value) {
    assert(name == name.toLowerCase());
    List<String> values = new List<String>();
    _headers[name] = values;
    values.add(value);
  }

  // Implemented to remove editor warnings
  dynamic noSuchMethod(Invocation invocation) {
    print([
      invocation.memberName,
      invocation.isGetter,
      invocation.isSetter,
      invocation.isMethod,
      invocation.isAccessor
    ]);
    return super.noSuchMethod(invocation);
  }

  void forEach(void f(String name, List<String> values)) => _headers.forEach(f);

  void clear() => _headers.clear();

  Map<String, String> get toMap {
    Map<String, String> ret = {};
    forEach((key, values) {
      if (values is List<String> && values.length > 0) {
        ret[key] = values[0];
      }
    });
    return ret;
  }
}
