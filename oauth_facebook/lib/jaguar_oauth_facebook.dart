// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library jaguar_oauth_facebook;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_oauth/jaguar_oauth.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:jaguar_facebook_client/jaguar_facebook_client.dart' as fb;

abstract class FbUserModel implements AuthorizationUser {
  String get fbId;

  String get fbToken;

  String get fbRefreshToken;
}

abstract class FbUserFetcher<UserModel extends FbUserModel>
    implements UserFetcher<UserModel> {
  Future<UserModel> getByFbId(String fbId);

  Future<UserModel> setFbCredentials(String authorizationId, String fbId, String fbToken,
      String fbRefreshToken);
}

class FbOauthConfig {
  final String key;

  final String secret;

  final String callbackUrl;

  final List<String> scopes;

  const FbOauthConfig({this.key, this.secret, this.callbackUrl, this.scopes});

  JaguarOauth2 get config => new JaguarOauth2(
        key: key,
        secret: secret,
        callback: callbackUrl,
        scopes: scopes,
        authorizationEndpoint: 'https://www.facebook.com/dialog/oauth',
        tokenEndpoint: 'https://graph.facebook.com/v2.8/oauth/access_token',
      );
}

class FbAuthenticator extends Interceptor {
  final FbUserFetcher userFetcher;

  final String authorizationIdKey;

  final bool manageSession;

  final FbOauthConfig oauthConfig;

  FbAuthenticator(
    this.userFetcher,
    this.oauthConfig, {
    this.authorizationIdKey: 'id',
    this.manageSession: true,
  });

  Future<void> call(Context ctx) async {
    oauth2.Client client =
        await oauthConfig.config.handleResponse(ctx); // TODO validate this

    final graph = new fb.GraphApi(client);
    final fields = new fb.UserFieldSelector()..addName();

    // TODO catch errors on this request
    final fb.UserResult resp = await graph.getMe(fields: fields);

    final FbUserModel subject = await userFetcher.getByFbId(resp.id);

    if (subject == null)
      throw new Response("Account for facebook user '${resp.name}' not found!",
          statusCode: HttpStatus.UNAUTHORIZED);

    if (manageSession) {
      final Session session = await ctx.session;
      // Invalidate old session data
      session.clear();
      // Add new session data
      session.addAll(
          <String, String>{authorizationIdKey: subject.authorizationId});
    }

    ctx.addVariable(subject);
  }
}

/// Links facebook with existing user account
class LinkFacebook implements Interceptor {
  final FbUserFetcher manager;

  final FbOauthConfig oauthConfig;

  const LinkFacebook(this.manager, this.oauthConfig);

  Future<void> call(Context ctx) async {
    AuthorizationUser subject = ctx.getVariable<AuthorizationUser>();

    if (subject == null)
      throw new Response("Unauthorized!", statusCode: HttpStatus.UNAUTHORIZED);

    oauth2.Client client =
        await oauthConfig.config.handleResponse(ctx); // TODO validate this

    final graph = new fb.GraphApi(client);
    final fields = new fb.UserFieldSelector();
    final fb.UserResult resp = await graph.getMe(fields: fields);

    subject = await manager.setFbCredentials(subject.authorizationId, resp.id,
        client.credentials.accessToken, client.credentials.refreshToken);

    if (subject == null) {
      // TODO throw ?
    }

    ctx.addVariable(subject);
  }
}
