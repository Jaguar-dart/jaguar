// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_oauth2;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

/// Model to configure OAuth2. Contains information to place OAuth2
/// authentication requests.
///
/// Create OAuth2 for Facebook's:
///     final config = new JaguarOauth2(
///         key: '',        // NOTE: Fill Facebook OAuth key
///         secret: '',     // NOTE: Fill Facebook OAuth secret
///         authorizationEndpoint: 'https://www.facebook.com/dialog/oauth',
///         tokenEndpoint: 'https://graph.facebook.com/v2.8/oauth/access_token',
///         callback: 'http://localhost:5555/api/auth/fb/login/authorized',  // NOTE: Use your server's callback endpoint here
///         scopes: ['email']);
///
/// Get the [Response] to redirect to authorization endpoint to initiate
/// authorization:
///     facebook.initiateRequest(ctx)
///
/// Handle response to authorization request:
///     oauth2.Client client = await facebook.handleResponse(ctx);
class JaguarOauth2 {
  /// The client identifier.
  ///
  /// The authorization server will issue each client a separate client
  /// identifier and secret, which allows the server to tell which client is
  /// accessing it. Some servers may also have an anonymous identifier/secret
  /// pair that any client may use.
  ///
  /// This is usually global to the program using this library.
  final String key;

  /// The client secret.
  ///
  /// The authorization server will issue each client a separate client
  /// identifier and secret, which allows the server to tell which client is
  /// accessing it. Some servers may also have an anonymous identifier/secret
  /// pair that any client may use.
  ///
  /// This is usually global to the program using this library.
  ///
  /// Note that clients whose source code or binary executable is readily
  /// available may not be able to make sure the client secret is kept a secret.
  /// This is fine; OAuth2 servers generally won't rely on knowing with
  /// certainty that a client is who it claims to be.
  final String secret;

  /// A URL provided by the authorization server that serves as the base for the
  /// URL that the resource owner will be redirected to to authorize this
  /// client.
  ///
  /// This will usually be listed in the authorization server's OAuth2 API
  /// documentation.
  ///
  /// For example, Facebook's authorization endpoint is:
  /// https://www.facebook.com/dialog/oauth
  final String authorizationEndpoint;

  /// A URL provided by the authorization server that this library uses to
  /// obtain long-lasting credentials.
  ///
  /// This will usually be listed in the authorization server's OAuth2 API
  /// documentation.
  ///
  /// For example, Facebook's token endpoint is:
  /// https://graph.facebook.com/v2.8/oauth/access_token
  final String tokenEndpoint;

  /// The scopes that the client is requesting access to.
  final List<String> scopes;

  /// Callback URL that is called after authentication
  final String callback;

  /// The granter
  final oauth2.AuthorizationCodeGrant granter;

  JaguarOauth2(
      {this.key,
      this.secret,
      this.authorizationEndpoint,
      this.tokenEndpoint,
      this.scopes,
      this.callback})
      : granter = new oauth2.AuthorizationCodeGrant(
            key, Uri.parse(authorizationEndpoint), Uri.parse(tokenEndpoint),
            secret: secret, basicAuth: false);

  Uri _authorizationUrl;

  Uri get authorizationUrl => _authorizationUrl ??=
      granter.getAuthorizationUrl(Uri.parse(callback), scopes: scopes);

  /// Initiates OAuth2 authorization request
  ///
  /// Sends authorization request to remote server by redirecting the browser to
  /// remote server's authorization request page
  Response<Uri> initiateRequest(Context ctx, {Response incoming}) {
    if (incoming != null) {
      final Response<Uri> ret = new Response.cloneExceptValue(incoming);
      ret.statusCode = HttpStatus.MOVED_TEMPORARILY;
      ret.value = authorizationUrl;
      return ret;
    } else {
      return new Response<Uri>(authorizationUrl,
          statusCode: HttpStatus.MOVED_TEMPORARILY);
    }
  }

  /// Handles OAuth2 authorization response
  Future<oauth2.Client> handleResponse(Context ctx) {
    authorizationUrl; // Dummy call to make sure authorization url is initialized
    final Map queryParams = ctx.queryParams;
    return granter.handleAuthorizationResponse(queryParams);
  }

  /// Handles OAuth2 authorization response
  Future<oauth2.Client> handleResponseWithParam(Map queryParams) {
    authorizationUrl; // Dummy call to make sure authorization url is initialized
    return granter.handleAuthorizationResponse(queryParams);
  }
}
