library testing.serve;

import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:jaguar/jaguar.dart';

import 'package:jaguar/src/serve/import.dart';

/// Mocks jaguar for testing
class JaguarMock extends Jaguar {
  JaguarMock(Configuration configuration) : super(configuration);

  @checked
  @override
  Future handleRequest(HttpRequest request) async {
    await super.handleRequest(request);
    return request.response;
  }

  @override
  Future<Null> serve() async {
    //Do nothing!
  }
}
