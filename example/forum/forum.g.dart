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
  ];

  Future<User> fetch();

  void delete(HttpRequest request, Db db);

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;

    match = _routes[0].match(args, request.uri.path, request.method);
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

    match = _routes[1].match(args, request.uri.path, request.method);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDbAdmin);
      delete(request, rMongoDbAdmin);
      iLogin.post();
      await iMongoDbAdmin.post();
      return true;
    }

    return false;
  }
}
