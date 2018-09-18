library jaguar_auth.authoriser;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import '../exception/exception.dart';

/// Authorizes the request
///
/// Arguments:
/// It uses [userFetcher] to fetch user model of the logged-in user.
///
/// Outputs ans Variables:
/// The authorised user model is injected into the context as input.
///
/// Exception:
/// An [UnauthorizedException] is thrown if the authorization fails.
class Authorizer<UserModel extends AuthorizationUser>
    implements Interceptor<UserModel> {
  /// Model manager used to fetch user model of the logged-in user
  final UserFetcher<UserModel> userFetcher;

  /// The key by which authorizationId is stored in session data
  final String authorizationIdKey;

  /// Should it throw 401 unauthorized error on authorization failure.
  final bool throwOnFail;

  const Authorizer(
      {this.userFetcher,
      this.authorizationIdKey: 'id',
      this.throwOnFail: true});

  Future<UserModel> call(Context ctx) async {
    final Session session = await ctx.session;
    final String authId = session[authorizationIdKey];
    if (authId is! String || authId.isEmpty) {
      if (throwOnFail) {
        throw UnauthorizedException.notLoggedIn;
      } else {
        return null;
      }
    }

    UserFetcher<UserModel> fetcher = userFetcher ?? ctx.userFetchers[UserModel];
    UserModel subject = await fetcher.byAuthorizationId(ctx, authId);

    if (subject == null) {
      if (throwOnFail) {
        throw UnauthorizedException.subjectNotFound;
      } else {
        return null;
      }
    }

    ctx.addVariable(subject);
    return subject;
  }

  /// Authorizes the request using the given [userFetcher].
  ///
  /// Arguments:
  /// It uses [userFetcher] to fetch user model of the logged-in user.
  ///
  /// Outputs ans Variables:
  /// The authorised user model is injected into the context as input.
  ///
  /// Exception:
  /// An [UnauthorizedException] is thrown if the authorization fails.
  static Future<UserModel> authorize<UserModel extends AuthorizationUser>(
      Context ctx,
      {UserFetcher<UserModel> userFetcher,
      String authorizationIdKey: 'id',
      bool throwOnFail: true}) async {
    final Session session = await ctx.session;
    final String authId = session[authorizationIdKey];
    if (authId is! String || authId.isEmpty) {
      if (throwOnFail) {
        throw UnauthorizedException.notLoggedIn;
      } else {
        return null;
      }
    }

    UserFetcher<UserModel> fetcher = userFetcher ?? ctx.userFetchers[UserModel];
    UserModel subject = await fetcher.byAuthorizationId(ctx, authId);

    if (subject == null) {
      if (throwOnFail) {
        throw UnauthorizedException.subjectNotFound;
      } else {
        return null;
      }
    }

    ctx.addVariable(subject);
    return subject;
  }
}
