import 'dart:async';
import 'package:jaguar/jaguar.dart';

export 'package:jaguar_common/jaguar_common.dart';

/// Interface to fetch user model by authentication and authorization IDs.
///
/// Used by Authorizers and Authenticators to fetch the user model.
abstract class UserFetcher<UserModel extends AuthorizationUser> {
  /// Fetches [UserModel] by given [authenticationId]
  FutureOr<UserModel> byAuthenticationId(Context ctx, String authenticationId);

  /// Fetches [UserModel] by given [authorizationId]
  FutureOr<UserModel> byAuthorizationId(Context ctx, String authorizationId);
}
