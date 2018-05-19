import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import 'model.dart';

/// Model manager to authenticate against a static list of user models
class WhiteListPasswordChecker implements AuthModelManager<User> {
  /// User models to white list
  final Map<String, User> models;

  /// Password hasher
  final Hasher hasher;

  const WhiteListPasswordChecker(Map<String, User> models, {Hasher hasher})
      : models = models ?? const {},
        hasher = hasher ?? const NoHasher();

  User authenticate(Context ctx, String username, String password) {
    User model = fetchByAuthenticationId(ctx, username);

    if (model == null) {
      return null;
    }

    if (!hasher.verify(password, model.password)) {
      return null;
    }

    return model;
  }

  User fetchByAuthenticationId(Context ctx, String authName) => models.values
      .firstWhere((model) => model.username == authName, orElse: () => null);

  User fetchByAuthorizationId(Context ctx, String sessionId) {
    if (!models.containsKey(sessionId)) {
      return null;
    }

    return models[sessionId];
  }
}
