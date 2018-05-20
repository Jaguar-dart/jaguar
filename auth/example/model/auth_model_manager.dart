import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import 'model.dart';

/// User models to white list
final Map<String, User> users = {
  '0': new User(id: '0', username: 'teja', password: 'word'),
};

/// Model manager to authenticate against a static list of user models
class WhiteListUserFetcher implements UserFetcher<User> {
  const WhiteListUserFetcher();

  User getByAuthenticationId(Context ctx, String username) => users.values
      .firstWhere((model) => model.username == username, orElse: () => null);

  User getByAuthorizationId(Context ctx, String id) => users[id];

  static const WhiteListUserFetcher userFetcher = const WhiteListUserFetcher();
}
