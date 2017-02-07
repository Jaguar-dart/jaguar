part of jaguar.src.http.response;

class JaguarHttpHeaders {
  final Map<String, List<String>> headers = {};

  operator [](String name) => headers[name];

  operator []=(String name, value) => set(name, value);

  String value(String name) {
    name = name.toLowerCase();
    List<String> values = headers[name];
    if (values == null) return null;
    return values[0];
  }

  void add(String name, Object value) {
    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _addValue(name, value[i]);
      }
    } else {
      _addValue(name, value);
    }
  }

  void set(String name, String value) {
    name = name.toLowerCase();
    List<String> values = new List<String>();
    headers[name] = values;
    values.add(value);
  }

  void remove(String name, Object value) {
    headers[name]?.remove(value);
  }

  void removeAll(String name) {
    headers.remove(name);
  }

  void forEach(void f(String name, List<String> values)) {
    headers.forEach(f);
  }

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

  set contentType(ContentType contentType) {
    if (contentType == null) return;
    set(HttpHeaders.CONTENT_TYPE, contentType.toString());
  }

  ContentType get contentType {
    String str = value(HttpHeaders.CONTENT_TYPE);
    if (str is! String) return null;
    return ContentType.parse(str);
  }

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
