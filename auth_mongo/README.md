# jaguar_auth_mongo

Jaguar AuthModelManager for MongoDb backend

## Usage

User model that implements `AuthorizationUser`.

```dart
class User implements AuthorizationUser {
  String id;

  String username;

  String password;

  User();

  User.make(this.id, this.username, this.password);

  String get authorizationId => id;
}
```

Mongo model manager to fetch and authenticate the user model.

```dart
final MgoUserManager<User> modelManager =
    new MgoUserManager<User>(userMgoSerializer);
```

Interface containing all the `MongoDb` and `Authorizer` interceptor creators.

```dart
abstract class BaseApi {
  /// Interceptor creator for authorization
  Authorizer authorizer(Context ctx) => new Authorizer(modelManager);

  /// Interceptor creator to connect to MongoDb
  MongoDb mongoDb(Context ctx) => new MongoDb('mongodb://localhost:27017/test');
}
```

Authorization routes.

```dart
/// This route group contains login and logout routes
@Api(path: '/auth')
@WrapOne(#mongoDb)
class AuthRoutes extends BaseApi {
  @Post(path: '/login')
  Future login(Context ctx) async {
    await BasicAuth.authenticate(ctx, modelManager);
  }

  @Post(path: '/logout')
  Future logout(Context ctx) async {
    // Clear session
    (await ctx.session).clear();
  }
}
```

Authorized routes.

```dart
/// Collection of routes students can also access
@Api(path: '/book')
@Wrap(const [#mongoDb, #authorizer])
class StudentRoutes extends BaseApi {
  @Get(path: '/all')
  Response<String> getAllBooks(Context ctx) {
    List<Map> ret =
        _books.values.map((Book book) => bookSerializer.toMap(book)).toList();
    return Response.json(ret);
  }

  @Get(path: '/:id')
  Response<String> getBook(Context ctx) {
    final String id = ctx.pathParams.get('id');
    final Book book = _books[id];
    return Response.json(bookSerializer.toMap(book));
  }
}
```
