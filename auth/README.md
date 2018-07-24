# jaguar_auth

Username password based authentication interceptors and helper functions for Jaguar. 
This package builds on  [`Session`](https://pub.dartlang.org/documentation/jaguar/latest/jaguar/Session-class.html)
infrastructure provided by Jaguar.

# Authorization

Authorization in `jaugar_auth` revolves around three basic principles:

+ **User Model**  
  A User model that can be uniquely identified.
+ **User Fetcher**  
  Logic to fetch the user model by its unique identity.
+ **Authorizer**  
  Checks if the request has correct and proper user identity.

## User model

[`AuthorizationUser`][AuthorizationUser] establishes an interface user models must
implement to operate with [`Authorizer`][Authorizer].

[`AuthorizationUser`][AuthorizationUser] demands that the model implements a
getter named [`authorizationId`][authorizationId] that uniquely identifies
the user. This is usually stored in session to associate session with a
user.

Typically, user id, email or username is used as [`authorizationId`][authorizationId].

### Example

The user model `User` uses user id as [`authorizationId`][authorizationId].
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

## User fetcher

[`UserFetcher`][UserFetcher] imposes an interface to fetch user model during authentication and authorization.
To achieve this, two methods shall be implemented: `byAuthenticationId` and `byAuthorizationId`.

### Example

```dart
class MgoUserManager<ModelType extends PasswordUser>
    implements UserFetcher<ModelType> {
  final String collection;

  final List<String> fieldNames;

  final Serializer<ModelType> serializer;

  MgoUserManager(this.serializer,
      {this.collection: 'user', this.fieldNames: const ['username']});

  Future<ModelType> byAuthorizationId(Context ctx, String userId) async {
    final Db db = ctx.getVariable<Db>();
    final DbCollection col = db.collection(collection);
    Map map = await col.findOne(mgo.where.id(mgo.ObjectId.parse(userId)));
    return serializer.fromMap(map);
  }

  Future<ModelType> byAuthenticationId(Context ctx, String authId) async {
    final Db db = ctx.getVariable<Db>();
    final DbCollection col = db.collection(collection);

    for (String fieldName in fieldNames) {
      Map map = await col.findOne(mgo.where.eq(fieldName, authId));
      if (map == null) continue;
      return serializer.fromMap(map);
    }

    return null;
  }
}
```

A user fetcher can be registered using `userFetchers` member of `Jaguar` class.

```dart
main() async {
  final server = new Jaguar(port: 10000);
  server.userFetchers[User] = MgoUserManager<User>(userMgoSerializer);
  // ... Add routes here ...
  await server.serve(logRequests: true);
}
```

## Authorizer

[`Authorizer`][Authorizer] authorizes the requests. If the authorization fails,
it responds with a 401 HTTP error. If the authorization succeeds, it returns the user model 
of the authorized user.

### Example

```dart
/// Collection of routes students can also access
@Controller(path: '/book')
@Intercept([mongoInterceptor, Authorizer<User>()])
class StudentRoutes {
  @Get(path: '/all')
  Response<String> getAllBooks(Context ctx) {
    List<Map> ret =
        _books.values.map((Book book) => bookSerializer.toMap(book)).toList();
    return Response.json(ret);
  }
}
```

# Authentication

Three types of authenticators are on offer:

1. [Basic auth][BasicAuth]
2. [Form auth][FormAuth]
3. [JSON auth][JsonAuth]

## Basic auth

BasicAuth performs authentication based on [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).

It expects base64 encoded "username:password" pair in "authorization" header with "Basic" scheme.

### Example

```dart
main() async {
  final server = Jaguar(port: 10000);
  server.postJson(
    '/login',
    // Authentication
    (Context ctx) async => await BasicAuth.authenticate<User>(ctx),
  );
  // ... Your routes here ...
  await server.serve();
}
```

## Form auth

An authenticator for standard username password form style login.
It expects a `application/x-www-form-urlencoded` encoded body where the
username and password form fields must be called `username` and `password`
respectively.

### Example

```dart
@Controller()
class AuthRoutes {
  @PostJson(path: '/login')
  @Intercept(const [const FormAuth<User>()])
  User login(Context ctx) => ctx.getVariable<User>();
}
```

## Json auth

An authenticator for standard username password login using ajax requests.
It expects a `application/json` encoded body where the
username and password fields must be called `username` and `password`
respectively.

### Example

```dart
@Controller()
class AuthRoutes {
  @PostJson(path: '/login')
  @Intercept(const [const JsonAuth<User>()])
  User login(Context ctx) => ctx.getVariable<User>();

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }
}
```

[BasicAuth]: https://pub.dartlang.org/documentation/jaguar_auth/latest/jaguar_auth/BasicAuth-class.html
[FormAuth]: https://pub.dartlang.org/documentation/jaguar_auth/latest/jaguar_auth/FormAuth-class.html
[JsonAuth]: https://pub.dartlang.org/documentation/jaguar_auth/latest/jaguar_auth/JsonAuth-class.html
[Authorizer]: https://pub.dartlang.org/documentation/jaguar_auth/latest/jaguar_auth/Authorizer-class.html
[UserFetcher]: https://pub.dartlang.org/documentation/jaguar/latest/jaguar/UserFetcher-class.html
[AuthorizationUser]: https://pub.dartlang.org/documentation/jaguar_common/latest/jaguar_common/AuthorizationUser-class.html
[authorizationId]: https://pub.dartlang.org/documentation/jaguar_common/latest/jaguar_common/AuthorizationUser/authorizationId.html
[byAuthenticationId]: https://pub.dartlang.org/documentation/jaguar/latest/jaguar/UserFetcher/byAuthenticationId.html
[byAuthorizationId]: https://pub.dartlang.org/documentation/jaguar/latest/jaguar/UserFetcher/byAuthorizationId.html