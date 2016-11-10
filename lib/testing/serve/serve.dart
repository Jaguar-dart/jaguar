library testing.serve;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/src/serve/error_writer/import.dart';

import 'package:jaguar/src/serve/import.dart';

/// Mocks jaguar for testing
class JaguarMock {
  Configuration config;

  JaguarMock(this.config);

  Future<HttpResponse> handleRequest(HttpRequest request) async {
    try {
      for (int i = 0; i < config.apis.length; i++) {
        var apiClass = config.apis[i];
        bool result = await apiClass.handleRequest(request);
        if (result) break;
      }
    } catch (e, stack) {
      writeErrorPage(request.response, request.uri.toString(), e, stack, 500);
    } finally {
      await request.response.close();
    }

    return request.response;
  }
}
