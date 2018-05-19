library jaguar_auth.authenticator;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_common/jaguar_common.dart';

export 'package:jaguar_common/jaguar_common.dart';

/// Specifies an interface that authenticators and authorizers use
/// to manage user model [AuthorizationUser]
abstract class AuthModelManager<ModelType extends AuthorizationUser> {
  /// Returns user model ([AuthorizationUser]) by given [authenticationId]
  FutureOr<ModelType> fetchByAuthenticationId(
      Context ctx, String authenticationId);

  /// Returns user model ([AuthorizationUser]) by given [authorizationId]
  FutureOr<ModelType> fetchByAuthorizationId(
      Context ctx, String authorizationId);

  /// Checks password [keyword] for given userId [authId] and
  /// returns the user ([AuthorizationUser]), if passwords match. Returns [null]
  /// if the password doesn't match or user with given authId is not found.
  FutureOr<ModelType> authenticate(Context ctx, String authId, String keyword);
}
