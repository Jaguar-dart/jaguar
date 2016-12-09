part of jaguar.src.interceptors;

class FormField {
  final String name;
  final value;
  final String contentType;
  final String filename;

  FormField(String this.name, this.value,
      {String this.contentType, String this.filename});

  bool operator ==(other) {
    if (value.length != other.value.length) return false;
    for (int i = 0; i < value.length; i++) {
      if (value[i] != other.value[i]) {
        return false;
      }
    }
    return name == other.name &&
        contentType == other.contentType &&
        filename == other.filename;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "FormField('$name', '$value', '$contentType', '$filename')";
  }
}

class WrapDecodeFormData implements RouteWrapper<DecodeFormData> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapDecodeFormData({this.id});

  DecodeFormData createInterceptor() => new DecodeFormData();
}

class DecodeFormData extends Interceptor {
  DecodeFormData();

  Future<Map<String, FormField>> pre(HttpRequest request) {
    if (!request.headers.contentType.parameters.containsKey('boundary')) {
      return null;
    }
    String boundary = request.headers.contentType.parameters['boundary'];
    return request
        .transform(new MimeMultipartTransformer(boundary))
        .map((part) => HttpMultipartFormData.parse(part))
        .map((multipart) {
          var future;
          if (multipart.isText) {
            future = multipart.join();
          } else {
            future = multipart.fold([], (b, s) => b..addAll(s));
          }
          return future.then((data) {
            String contentType;
            if (multipart.contentType != null) {
              contentType = multipart.contentType.mimeType;
            }
            return new FormField(
                multipart.contentDisposition.parameters['name'], data,
                contentType: contentType,
                filename: multipart.contentDisposition.parameters['filename']);
          });
        })
        .toList()
        .then((List future) async {
          Iterable<Future<FormField>> list =
              future.map((Future<FormField> f) => f);
          return await Future.wait(list);
        })
        .then((List<FormField> formFields) {
          Map<String, FormField> mapped = <String, FormField>{};
          formFields.forEach(
              (FormField formField) => mapped[formField.name] = formField);
          return mapped;
        });
  }
}
