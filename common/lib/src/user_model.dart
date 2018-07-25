library jaguar_common.user_model;

abstract class AuthorizationUser {
  /// Authorization Id is the field used to identify the logged in user in
  /// session data
  ///
  /// Could be unique user id, username, email
  String get authorizationId;
}

/// Interface for a user model with a password
abstract class PasswordUser implements AuthorizationUser {
  /// Secret password the user uses to authenticate.
  String get password;
}

/// [AuthorizationUser] that uses email as authenticationId and unique record id as
/// authorizationId
abstract class UserEmail implements PasswordUser {
  String get id;

  String get email;

  String get authorizationId => id;
}

/// [AuthorizationUser] that uses username as authenticationId and unique record id as
/// authorizationId
abstract class UserUsername implements PasswordUser {
  String get id;

  String get username;

  String get authorizationId => id;
}

/// [AuthorizationUser] that uses username and email as authenticationId and unique
/// record id as authorizationId
abstract class UserUsernameEmail implements PasswordUser {
  String get id;

  String get username;

  String get email;

  String get authorizationId => id;
}
