# jaguar_auth

Authentication interceptors and helper functions for Jaguar. This package builds on 
[`Session`](https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Session-class.html)
infrastructure provided by `jaguar`.

This package provides three types of authentication:

1. [Basic auth][BasicAuth]
2. [Form auth][FormAuth]
3. [JSON auth][JsonAuth]

And an [Authorizer][Authorizer]

# User model

[`AuthorizationUser`][AuthorizationUser] is the interface user models must
implement to work with [`Authorizer`][Authorizer] and [`AuthModelManager`][AuthModelManager].

[`AuthorizationUser`][AuthorizationUser] demands that the model implements a
getter named [`authorizationId`][authorizationId] that uniquely identifies
the user. This is usually stored in session to associate session with a
user.

Typically, user id, email or username is used as [`authorizationId`][authorizationId].

## Example

The user model `User` uses user-id as [`authorizationId`][authorizationId].
Notice that `User` implements `AuthorizationUser` interface.

```dart
class User implements AuthorizationUser {
  String id;

  String username;

  String password;

  User(this.id, this.username, this.password);

  String get authorizationId => id;
}
```

# Model manager

[`AuthModelManager`][AuthModelManager] implements methods to fetch the user model
and also to authenticate the user against a password in a username-password
setup. This decouples data layer from the authentication logic. Authenticators and
Authorizers use [`AuthModelManager`][AuthModelManager] to stay database
agnostic.

[`AuthModelManager`][AuthModelManager] defines three methods:

1. [`fetchModelByAuthenticationId`][fetchModelByAuthenticationId]
[`fetchModelByAuthenticationId`][fetchModelByAuthenticationId] is used by
[`authenticate`][authenticate] method to fetch user model by authentication id.
Typically, username, email or even phone number is used as authentication id.
2. [`fetchModelByAuthorizationId`][fetchModelByAuthorizationId]
[`fetchModelByAuthorizationId`][fetchModelByAuthorizationId] is used by
[`Authorizer`][Authorizer] to identify and fetch the user model from data store.
3. [`authenticate`][authenticate]
[`authenticate`][authenticate] method authenticates a user given their authentication
id and a passphrase.
Internally, [`authenticate`][authenticate] uses [`fetchModelByAuthenticationId`][fetchModelByAuthenticationId]
to fetch the user model by authentication id from the data storage.
It then verifies that the pass phrase matches the one the model has.

## Example

```dart
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


final Map<String, User> kUsers = {
  '0': new User('0', 'teja', 'word'),
  '1': new User('1', 'kleak', 'pass'),
};

final WhiteListPasswordChecker kModelManager =
    new WhiteListPasswordChecker(kUsers);
```

## AuthModelManager implementations

Several implementation of [`AuthModelManager`][AuthModelManager] exist:

1. MongoDB based
2. PostgreSQL based
3. Whitelist

# Authorizer

[`Authorizer`][Authorizer] authorizes the requests. If the authorization fails,
it responds with a 401 http error.
If the authorization succeeds, it returns the user model of the authorized user.

## Example

```dart
/// Collection of routes students can also access
@Api(path: '/book')
class StudentRoutes extends Object with JsonRoutes {
  JsonRepo get repo => jsonRepo;

  @Get()
  Future<Response<String>> getAllBooks(Context ctx) async {
    // Authorize. Throws 401 http error, if authorization fails!
    await Authorizer.authorize(ctx, kModelManager);

    return toJson(_books.values);
  }

  @Get(path: '/:id')
  Future<Response<String>> getBook(Context ctx) async {
    // Authorize. Throws 401 http error, if authorization fails!
    await Authorizer.authorize(ctx, kModelManager);

    String id = ctx.pathParams.get('id');
    Book book = _books[id];
    return toJson(book);
  }
}
```

# Basic auth

BasicAuth performs authentication based on [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).

It expects base64 encoded "username:password" pair in "authorization" header with "Basic" scheme.

## Example

```dart
/// This route group contains login and logout routes
@Api()
class AuthRoutes extends Object with JsonRoutes {
  JsonRepo get repo => jsonRepo;

  @Post(path: '/login')
  @WrapOne(basicAuth) // Wrap basic authenticator
  Response<String> login(Context ctx) {
    final User user = ctx.getInterceptorResult<User>(BasicAuth);
    return toJson(user);
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }

  static BasicAuth basicAuth(Context ctx) => new BasicAuth(kModelManager);
}
```

## Example client

> TODO

```dart

```

# Form auth

An authenticator for standard username password form style login.
It expects a `application/x-www-form-urlencoded` encoded body where the
username and password form fields must be called `username` and `password`
respectively.

## Example

```dart
/// This route group contains login and logout routes
@Api()
class AuthRoutes extends Object with JsonRoutes {
  JsonRepo get repo => jsonRepo;

  @Post(path: '/login')
  @WrapOne(formAuth)
  Response<String> login(Context ctx) {
    final User user = ctx.getInterceptorResult<User>(FormAuth);
    return toJson(user);
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }

  static FormAuth formAuth(Context ctx) => new FormAuth(kModelManager);
}
```

## Example client

> TODO

# Json auth

An authenticator for standard username password login using ajax requests.
It expects a `application/json` encoded body where the
username and password fields must be called `username` and `password`
respectively.

## Example

```dart
/// This route group contains login and logout routes
@Api()
class AuthRoutes extends Object with JsonRoutes {
  JsonRepo get repo => jsonRepo;

  @Post(path: '/login')
  @WrapOne(jsonAuth)
  Response<String> login(Context ctx) {
    final User user = ctx.getInterceptorResult<User>(JsonAuth);
    return toJson(user);
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }

  /// The authenticator
  static JsonAuth jsonAuth(Context ctx) => new JsonAuth(kModelManager);
}
```

## Example client

> TODO

[BasicAuth]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/BasicAuth-class.html
[FormAuth]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/FormAuth-class.html
[JsonAuth]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/JsonAuth-class.html
[Authorizer]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/Authorizer-class.html
[AuthModelManager]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/AuthModelManager-class.html
[AuthorizationUser]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/AuthorizationUser-class.html
[authorizationId]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/AuthorizationUser/authorizationId.html
[fetchModelByAuthenticationId]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/AuthModelManager/fetchModelByAuthenticationId.html
[fetchModelByAuthorizationId]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/AuthModelManager/fetchModelByAuthorizationId.html
[authenticate]: https://www.dartdocs.org/documentation/jaguar_auth/latest/jaguar_auth/AuthModelManager/authenticate.html