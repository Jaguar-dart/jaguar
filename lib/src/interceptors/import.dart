library jaguar.src.interceptors;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';

part 'decode/form_data.dart';
part 'decode/json.dart';
part 'decode/url_encoded_form.dart';
part 'encode/json.dart';

Future<String> getStringFromBody(HttpRequest request, Encoding encoding) async {
  Completer<String> completer = new Completer<String>();
  String allData = "";
  request.transform(encoding.decoder).listen((String data) => allData += data,
      onDone: () => completer.complete(allData));
  return completer.future;
}
