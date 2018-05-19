library jaguar_auth.authoriser;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/src/entity/entity.dart';

/// Authorizes the request
///
/// Arguments:
/// It uses [modelManager] to fetch user model of the logged-in user
///
/// Outputs ans Variables:
/// The authorised user model is injected into the context as input
class Authorizer {
  /// Model manager used to fetch user model of the logged-in user
  final AuthModelManager modelManager;

  /// The key by which authorizationId is stored in session data
  final String authorizationIdKey;

  Authorizer(this.modelManager, {this.authorizationIdKey: 'id'});

  Future before(Context ctx) async {
    final Session session = await ctx.session;
    final String authId = session[authorizationIdKey];
    if (authId is! String || authId.isEmpty) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    AuthorizationUser subject =
        await modelManager.fetchByAuthorizationId(ctx, authId);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    ctx.addVariable(subject);
  }

  /// Authorizes a request with the given [AuthModelManager]
  static Future<ModelType> authorize<ModelType extends AuthorizationUser>(
      Context ctx, AuthModelManager<ModelType> modelManager,
      {String authorizationIdKey: 'id'}) async {
    final Session session = await ctx.session;
    final String id = session[authorizationIdKey];
    if (id is! String || id.isEmpty) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    ModelType subject = await modelManager.fetchByAuthorizationId(ctx, id);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    return subject;
  }
}
