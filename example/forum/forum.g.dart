// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.forum;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ForumApi
// **************************************************************************

abstract class _$JaguarForumApi {
  List<Route> _routes = <Route>[
    new Route(r"/api/user", methods: ["GET"]),
    new Route(r"/api/user", methods: ["DELETE"]),
    new Route(r"/api/user/:param1", methods: ["POST"]),
    new Route(r"/api/user", methods: ["PUT"]),
    new Route(r"/api/user1", methods: ["PUT"]),
    new Route(r"/api/user2", methods: ["PUT"]),
  ];

  Future<User> fetch();

  void delete(HttpRequest request, Db db);

  User create(HttpRequest request, Db db, String email, String name,
      String password, int age);

  String update(HttpRequest request, Db db, String param1,
      {int param2: 5555, int param3: 55});

  String update1(HttpRequest request, Db db, PathParams pathParams);

  String update2(HttpRequest request, Db db, ParamCreate pathParams);

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams();
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);
    bool match = false;

    match = _routes[0].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbTest = new MongoDb('test', id: 'Test');
      await iMongoDbTest.pre();
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      EncodeObject iEncodeObject = new EncodeObject();
      User rResponse;
      rResponse = await fetch();
      request.response.statusCode = 201;
      request.response.headers.add("sample-header", "made-with.jaguar");
      iEncodeObject.post();
      await iMongoDbAdmin.post();
      await iMongoDbTest.post();
      return true;
    }

    match = _routes[1].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      delete(
        request,
        rMongoDbAdmin,
      );
      await iMongoDbAdmin.post();
      return true;
    }

    match = _routes[2].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      User rResponse;
      rResponse = create(
        request,
        rMongoDbAdmin,
        (pathParams.getField('email') ?? queryParams.getField('email')),
        (pathParams.getField('name') ?? queryParams.getField('name')),
        (pathParams.getField('password') ?? queryParams.getField('password')),
        stringToInt(pathParams.getField('age') ?? queryParams.getField('age')),
      );
      request.response.statusCode = 200;
      request.response.write(rResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match = _routes[3].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      String rResponse;
      rResponse = update(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1') ?? queryParams.getField('param1')),
        param2: stringToInt(pathParams.getField('param2') ??
                queryParams.getField('param2')) ??
            5555,
        param3: stringToInt(pathParams.getField('param3') ??
                queryParams.getField('param3')) ??
            55,
      );
      request.response.statusCode = 200;
      request.response.write(rResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match = _routes[4].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      String rResponse;
      PathParams injectPathParam = new PathParams.FromPathParam(pathParams);
      rResponse = update1(
        request,
        rMongoDbAdmin,
        injectPathParam,
      );
      request.response.statusCode = 200;
      request.response.write(rResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match = _routes[5].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      String rResponse;
      try {
        ParamCreate injectPathParam = new ParamCreate.FromPathParam(pathParams);
        if (injectPathParam is Validatable) {
          injectPathParam.validate();
        }
        rResponse = update2(
          request,
          rMongoDbAdmin,
          injectPathParam,
        );
      } on ParamValidationException catch (e, s) {
        ParamValidationExceptionHandler handler =
            new ParamValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      request.response.statusCode = 200;
      request.response.write(rResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    return false;
  }
}
