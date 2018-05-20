// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_oauth2;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_session/jaguar_session.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_oauth/jaguar_oauth.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:jaguar_facebook_client/jaguar_facebook_client.dart' as fb;

part 'link.dart';

abstract class FacebookUserModel implements AuthorizationUser {
  String get fbId;

  String get fbToken;

  String get fbRefreshToken;
}

abstract class FacebookModelManager implements AuthModelManager {
  Future<FacebookUserModel> fetchModelByFbId(String fbId);

  Future<Null> setFbInfo(FacebookUserModel model, String fbId, String fbToken,
      String fbRefreshToken);
}

class FacebookAuth extends Interceptor {
  final FacebookModelManager manager;

  final String authorizationIdKey;

  final bool manageSession;

  FacebookAuth(this.manager,
      {this.authorizationIdKey: 'id', this.manageSession: true});

  Future<FacebookUserModel> pre(Context ctx) async {
    oauth2.Client client = ctx.getInput(OAuth2Authorized);
    SessionManager sessionManager = ctx.getVariable<SessionManager>();

    final graph = new fb.GraphApi(client);
    final fields = new fb.UserFieldSelector()
      ..addBirthday()
      ..addAbout()
      ..addEmail()
      ..addName();
    final fb.UserResult resp = await graph.getMe(fields: fields);

    final FacebookUserModel model = await manager.fetchModelByFbId(resp.id);

    if (model == null) {
      throw new UnAuthorizedError();
    }

    if (manageSession) {
      sessionManager.updateSession({authorizationIdKey: model.authorizationId});
    }

    return model;
  }
}
