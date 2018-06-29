import 'package:jaguar/jaguar.dart';

import 'model.dart';

/// User models to white list
final Map<String, User> users = {
  '0': new User(id: '0', username: 'teja', password: 'word'),
};

/// Model manager to authenticate against a static list of user models
class DummyFetcher implements UserFetcher<User> {
  const DummyFetcher();

  User byAuthenticationId(Context ctx, String username) => users.values
      .firstWhere((model) => model.username == username, orElse: () => null);

  User byAuthorizationId(Context ctx, String id) => users[id];
}
