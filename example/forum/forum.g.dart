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
  ];

  Future<User> fetch();

  void delete(HttpRequest request, Db db);

  String create(HttpRequest request, Db db, String param1,
      [int param2 = 25, int param3 = 5]);

  String update(HttpRequest request, Db db, String param1,
      {int param2: 5555, int param3: 55});

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams({});
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);
    bool match = false;

    match = _routes[0].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbTest = new MongoDb('test', id: 'Test');
      Db rMongoDbTest = await iMongoDbTest.pre();
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDbAdmin);
      User rResponse = await fetch();
      request.response.statusCode = 201;
      request.response.headers.add("sample-header", "made-with.jaguar");
      request.response
        ..write(rResponse.toString())
        ..close();
      iLogin.post();
      await iMongoDbAdmin.post();
      await iMongoDbTest.post();
      return true;
    }

    match = _routes[1].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDbAdmin);
      delete(
        request,
        rMongoDbAdmin,
      );
      iLogin.post();
      await iMongoDbAdmin.post();
      return true;
    }

    match = _routes[2].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDbAdmin);
      String rResponse = create(
        request,
        rMongoDbAdmin,
        pathParams.getField('param1') ?? queryParams.getField('param1'),
      );
      request.response.statusCode = 200;
      request.response
        ..write(rResponse.toString())
        ..close();
      iLogin.post();
      await iMongoDbAdmin.post();
      return true;
    }

    match = _routes[3].match(request.uri.path, request.method, pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDbAdmin);
      String rResponse = update(
        request,
        rMongoDbAdmin,
        pathParams.getField('param1') ?? queryParams.getField('param1'),
        param2: pathParams.getField('param2') ?? queryParams.getField('param2'),
        param3: pathParams.getField('param3') ?? queryParams.getField('param3'),
      );
      request.response.statusCode = 200;
      request.response
        ..write(rResponse.toString())
        ..close();
      iLogin.post();
      await iMongoDbAdmin.post();
      return true;
    }

    return false;
  }
}
