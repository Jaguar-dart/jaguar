// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_cors;

import 'dart:io' show HttpStatus;
import 'package:jaguar/jaguar.dart';

part 'options.dart';
part 'request_params.dart';

/// Interceptor to handle CORS related requests
class Cors implements Interceptor<void> {
  final CorsOptions options;

  Cors(this.options);

  _CorsRequestParams params;

  bool _isCors = false;

  bool get isCors => _isCors;

  bool _isPreflight = false;

  bool get isPreflight => _isPreflight;

  String _errorMsg;

  String get errorMsg => _errorMsg;

  bool get hasError => _errorMsg != null;

  void call(Context ctx) {
    final Request req = ctx.req;
    params = _CorsRequestParams.fromRequest(req);

    // Check if it is CORS request
    if (params.origin is! String) {
      if (!options.allowNonCorsRequests) {
        throw Response('Only Cross origin requests are allowed!',
            statusCode: HttpStatus.forbidden);
      }
      return;
    }

    ctx.after.add(after);

    _isCors = true;

    if (req.method == 'OPTIONS' && params.method is String) {
      _isPreflight = true;
    }

    _filterOrigin();

    if (errorMsg == null) {
      _filterMethods(req);

      if (errorMsg == null) {
        _filterHeaders(req);
      }
    }

    if (errorMsg != null) {
      throw Response('Invalid CORS request: ' + errorMsg,
          statusCode: HttpStatus.forbidden);
    }
  }

  void _filterOrigin() {
    if (options.allowAllOrigins) return;

    if (options.allowedOrigins == null) {
      _errorMsg = 'Origin not allowed!';
      return;
    }

    if (!options.allowedOrigins.contains(params.origin)) {
      _errorMsg = 'Origin not allowed!';
      return;
    }
  }

  void _filterMethods(Request req) {
    String method;

    if (isPreflight) {
      method = params.method;
    } else {
      method = req.method;
    }

    if (options.allowAllMethods) return;

    if (options.allowedMethods.length == 0) {
      _errorMsg = 'Method not allowed!';
      return;
    }

    if (!options.allowedMethods.contains(method)) {
      _errorMsg = 'Method not allowed!';
      return;
    }
  }

  void _filterHeaders(Request req) {
    final List<String> headers = [];

    if (isPreflight) {
      // If preflight, check that all headers supplied in 'Access-Control-Request-Headers'
      // are accepted
      if (params.headers is List<String>) {
        headers.addAll(params.headers);
      }
    } else {
      req.headers.forEach((String header, _) => headers.add(header));
    }

    if (headers.length == 0) return;

    if (options.allowAllHeaders) return;

    if (options.allowedHeaders == null) {
      _errorMsg = 'Header not allowed!';
      return;
    }

    for (String header in headers) {
      if (!options.allowedHeaders.contains(header)) {
        _errorMsg = 'Header not allowed!';
        return;
      }
    }
  }

  void after(Context ctx) {
    if (!isCors) return;

    Response response = ctx.response;

    if (options.allowAllOrigins) {
      response.headers.set(_CorsHeaders.AllowedOrigin, '*');
    } else {
      response.headers
          .set(_CorsHeaders.AllowedOrigin, options.allowedOrigins.join(', '));
    }

    if (options.vary) {
      response.headers.set(_CorsHeaders.Vary, 'true');
    }

    if (options.allowCredentials) {
      response.headers.set(_CorsHeaders.AllowCredentials, 'true');
    }

    if (isPreflight) {
      if (options.allowAllMethods) {
        response.headers.set(_CorsHeaders.AllowedMethods, '*');
      } else if (options.allowedMethods.length != 0) {
        response.headers.set(
            _CorsHeaders.AllowedMethods, options.allowedMethods.join(', '));
      }

      if (options.allowAllHeaders) {
        response.headers.set(_CorsHeaders.AllowedHeaders, '*');
      } else if (options.allowedHeaders.length != 0) {
        response.headers.set(
            _CorsHeaders.AllowedHeaders, options.allowedHeaders.join(', '));
      }

      if (options.maxAge is int) {
        response.headers.set(_CorsHeaders.MaxAge, options.maxAge.toString());
      }

      response.statusCode = 200;
    } else {
      if (options.exposeAllHeaders) {
        response.headers.set(_CorsHeaders.ExposeHeaders, '*');
      } else if (options.exposeHeaders.length != 0) {
        response.headers
            .set(_CorsHeaders.ExposeHeaders, options.exposeHeaders.join(', '));
      }
    }
  }
}
