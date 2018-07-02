library jaguar_auth.authoriser;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Authorizes the request
///
/// Arguments:
/// It uses [userFetcher] to fetch user model of the logged-in user
///
/// Outputs ans Variables:
/// The authorised user model is injected into the context as input
class Authorizer<UserModel extends AuthorizationUser> implements Interceptor {
  /// Model manager used to fetch user model of the logged-in user
  final UserFetcher<UserModel> userFetcher;

  /// The key by which authorizationId is stored in session data
  final String authorizationIdKey;

  const Authorizer({this.userFetcher, this.authorizationIdKey: 'id'});

  Future<void> call(Context ctx) async {
    final Session session = await ctx.session;
    final String authId = session[authorizationIdKey];
    if (authId is! String || authId.isEmpty) {
      throw new Response(null, statusCode: HttpStatus.unauthorized);
    }

    UserFetcher<UserModel> fetcher = userFetcher ?? ctx.userFetchers[UserModel];
    UserModel subject = await fetcher.byAuthorizationId(ctx, authId);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.unauthorized);
    }

    ctx.addVariable(subject);
  }

  /// Authorizes a request with the given [UserFetcher]
  static Future<UserModel> authorize<UserModel extends AuthorizationUser>(
      Context ctx,
      {UserFetcher<UserModel> userFetcher,
      String authorizationIdKey: 'id'}) async {
    final Session session = await ctx.session;
    final String authId = session[authorizationIdKey];
    if (authId is! String || authId.isEmpty) {
      throw new Response(null, statusCode: HttpStatus.unauthorized);
    }

    UserFetcher<UserModel> fetcher = userFetcher ?? ctx.userFetchers[UserModel];
    UserModel subject = await fetcher.byAuthorizationId(ctx, authId);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.unauthorized);
    }

    return subject;
  }
}
