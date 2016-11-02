library jaguar.src.interceptors;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';

Future<String> getStringFromBody(HttpRequest request) async {
  Completer<String> completer = new Completer<String>();
  String allData = "";
  //  TODO: add error
  request.transform(UTF8.decoder).listen((String data) => allData += data,
      onDone: () => completer.complete(allData));
  return completer.future;
}

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

@InterceptorClass()
class FormData extends Interceptor {
  const FormData();

  Future<Map<String, FormField>> pre(HttpRequest request) {
    print(request.headers.contentType.parameters);
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

@InterceptorClass()
class XWwwFormUrlEncoded extends Interceptor {
  const XWwwFormUrlEncoded();

  Future<Map<String, String>> pre(HttpRequest request) async {
    print(request.headers);
    return (await getStringFromBody(request))
        .split("&")
        .map((String part) => part.split("="))
        .map((List<String> part) => <String, String>{part.first: part.last})
        .reduce((Map<String, String> value, Map<String, String> element) =>
            value..putIfAbsent(element.keys.first, () => element.values.first));
  }
}

@InterceptorClass()
class DecodeJsonMap extends Interceptor {
  const DecodeJsonMap();

  Future<Map<dynamic, dynamic>> pre(HttpRequest request) async {
    String data = await getStringFromBody(request);
    return JSON.decode(data);
  }
}
