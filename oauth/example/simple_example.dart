// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_oauth/jaguar_oauth.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:logging/logging.dart';
import 'package:jaguar_settings/jaguar_settings.dart';

@Controller(path: '/auth')
class AuthRoutes {
  /// Route that initiates the OAuth2 authorization request by redirecting to
  /// authorization endpoint
  @Get(path: '/fb/authreq')
  Response<Uri> fbAuthReq(ctx) => facebook.initiateRequest(ctx);

  /// Route that handles OAuth2 authorization response callback
  @Get(path: '/fb/authorized', mimeType: 'application/json')
  Future<String> fbAuthorized(Context ctx) async {
    // Get the [Client] from authorization response callback
    oauth2.Client client = await facebook.handleResponse(ctx);
    // Use Facebook OAuth2 APIs
    final resp = await client.get('https://graph.facebook.com/v2.8/me');
    return resp.body;
  }

  /// Facebook OAuth2 configuration
  JaguarOauth2 get facebook => new JaguarOauth2(
      key: fbOauthKey,
      secret: fbOauthSecret,
      authorizationEndpoint: 'https://www.facebook.com/dialog/oauth',
      tokenEndpoint: 'https://graph.facebook.com/v2.8/oauth/access_token',
      callback: baseUrl + '/api/auth/fb/authorized',
      scopes: ['email']);
}

@Controller(path: '/api')
class MyApi {
  @IncludeHandler()
  final AuthRoutes auth = new AuthRoutes();
}

const String baseUrl = 'http://localhost:5555';
String get fbOauthKey => Settings.getString('facebook_oauth_key',
    settingsFilter: SettingsFilter.Env);
String get fbOauthSecret => Settings.getString('facebook_oauth_secret',
    settingsFilter: SettingsFilter.Env);

main(List<String> args) async {
  await Settings.parse(args);
  final server = new Jaguar(port: 5555);
  server.add(reflect(new MyApi()));

  server.log.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  await server.serve();
}
