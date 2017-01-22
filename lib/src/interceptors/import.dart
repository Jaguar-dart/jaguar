library jaguar.src.interceptors;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';

part 'decode/form_data.dart';
part 'decode/json/generic.dart';
part 'decode/json/map.dart';
part 'decode/json/list.dart';
part 'decode/url_encoded_form.dart';
part 'encode/json.dart';

/* TODO
Future<String> getStringFromBody(Request request, Encoding encoding) async {
  final List<int> body = await request.body;
  return encoding.decode(body);
}
*/
