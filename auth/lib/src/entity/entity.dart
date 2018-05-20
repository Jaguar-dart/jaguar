library jaguar_auth.authenticator;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_common/jaguar_common.dart';

export 'package:jaguar_common/jaguar_common.dart';

/// Specifies an interface that authenticators and authorizers use
/// to manage user model [AuthorizationUser]
abstract class UserFetcher<UserType extends AuthorizationUser> {
  /// Returns user model ([AuthorizationUser]) by given [authenticationId]
  FutureOr<UserType> getByAuthenticationId(
      Context ctx, String authenticationId);

  /// Returns user model ([AuthorizationUser]) by given [authorizationId]
  FutureOr<UserType> getByAuthorizationId(Context ctx, String authorizationId);
}
