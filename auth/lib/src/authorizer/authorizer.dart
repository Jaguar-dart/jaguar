library jaguar_auth.authoriser;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/src/entity/entity.dart';

/// Authorizes the request
///
/// Arguments:
/// It uses [userFetcher] to fetch user model of the logged-in user
///
/// Outputs ans Variables:
/// The authorised user model is injected into the context as input
class Authorizer implements Interceptor {
  /// Model manager used to fetch user model of the logged-in user
  final UserFetcher userFetcher;

  /// The key by which authorizationId is stored in session data
  final String authorizationIdKey;

  const Authorizer(this.userFetcher, {this.authorizationIdKey: 'id'});

  Future<void> call(Context ctx) async {
    final Session session = await ctx.session;
    final String authId = session[authorizationIdKey];
    if (authId is! String || authId.isEmpty) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    AuthorizationUser subject =
        await userFetcher.getByAuthorizationId(ctx, authId);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    ctx.addVariable(subject);
  }

  /// Authorizes a request with the given [UserFetcher]
  static Future<ModelType> authorize<ModelType extends AuthorizationUser>(
      Context ctx, UserFetcher<ModelType> userFetcher,
      {String authorizationIdKey: 'id'}) async {
    final Session session = await ctx.session;
    final String id = session[authorizationIdKey];
    if (id is! String || id.isEmpty) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    ModelType subject = await userFetcher.getByAuthorizationId(ctx, id);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    return subject;
  }
}
