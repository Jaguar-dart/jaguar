part of jaguar.src.http.response;

/// Class to hold HTTP headers
class JaguarHttpHeaders {
  final Map<String, List<String>> headers = {};

  /// Returns value for the given header name
  operator [](String name) => headers[name];

  /// Sets a header value by given header name
  operator []=(String name, value) => set(name, value);

  /// Returns header value by `name`
  ///
  /// If there is no header with the provided name, null will be returned. If the
  /// header has more than one value, first value will be returned.
  String value(String name) {
    name = name.toLowerCase();
    List<String> values = headers[name];
    if (values == null) return null;
    return values[0];
  }

  /// Adds a header value. The header named `name` will have the value `value` added
  /// to its list of values.
  ///
  /// If the value is of type DateTime a HTTP date format will be applied. If the
  /// value is a List each element of the list will be added separately.
  ///
  /// For all other types the default toString method will be used.
  void add(String name, Object value) {
    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _addValue(name, value[i]);
      }
    } else {
      _addValue(name, value);
    }
  }

  /// Sets a header. The header named name will have all its values cleared before
  /// the value value is added as its value.
  void set(String name, String value) {
    name = name.toLowerCase();
    List<String> values = new List<String>();
    headers[name] = values;
    values.add(value);
  }

  /// Removes a specific value for a header `name`
  void remove(String name, Object value) {
    headers[name]?.remove(value);
  }

  /// Removes all values for the specified header `name`
  void removeAll(String name) {
    headers.remove(name);
  }

  /// Enumerates the headers, applying the function `f` to each header. The header
  /// name passed in `name` will be all lower case.
  void forEach(void f(String name, List<String> values)) {
    headers.forEach(f);
  }

  /// Remove all headers
  void clear() {
    headers.clear();
  }

  void _addValue(String name, Object value) {
    List<String> values = headers[name];
    if (values == null) {
      values = new List<String>();
      headers[name] = values;
    }
    if (value is DateTime) {
      values.add(HttpDate.format(value));
    } else {
      values.add(value.toString());
    }
  }

  /// Gets and sets the content type
  set contentType(ContentType contentType) {
    if (contentType == null) return;
    set(HttpHeaders.CONTENT_TYPE, contentType.toString());
  }

  ContentType get contentType {
    String str = value(HttpHeaders.CONTENT_TYPE);
    if (str is! String) return null;
    return ContentType.parse(str);
  }

  /// Sets and gets mime-type
  String get mimeType => contentType?.mimeType;

  set mimeType(String mimeType) {
    ContentType contentType = this.contentType;
    if (contentType == null) {
      if (mimeType != null && mimeType.isNotEmpty) {
        ContentType newContentType = ContentType.parse(mimeType);
        this.contentType = newContentType;
      }
    } else {
      if (mimeType != null && mimeType.isNotEmpty) {
        ContentType newContentType = ContentType.parse(mimeType);
        this.contentType = new ContentType(
            newContentType.primaryType, newContentType.subType,
            charset: contentType.charset, parameters: contentType.parameters);
      } else {
        this.contentType =
            new ContentType('', '', parameters: contentType.parameters);
      }
    }
  }

  /// Sets and gets charset
  String get charset => contentType?.charset;

  set charset(String charset) {
    ContentType contentType = this.contentType;
    if (contentType == null) {
      if (charset != null && charset.isNotEmpty) {
        this.contentType = new ContentType(
            ContentType.TEXT.primaryType, ContentType.TEXT.subType,
            charset: charset);
      }
    } else {
      if (charset != null && charset.isNotEmpty) {
        this.contentType = new ContentType(
            contentType.primaryType, contentType.subType,
            charset: charset, parameters: contentType.parameters);
      } else {
        this.contentType = new ContentType(
            contentType.primaryType, contentType.subType,
            parameters: contentType.parameters..remove('charset'));
      }
    }
  }
}
