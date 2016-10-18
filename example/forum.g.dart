// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.forum;

// **************************************************************************
// Generator: ApiGenerator
// Target: class Forum
// **************************************************************************

abstract class _$JaguarForum {
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
      MongoDb iMongoDb = new MongoDb('test');
      Db rMongoDb = iMongoDb.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDb);
      fetch();
      iLogin.post();
      iMongoDb.post();
      return true;
    }

    match = _routes[1].match(args, request.uri.path, request.method);
    if (match) {
      MongoDb iMongoDb = new MongoDb('test');
      Db rMongoDb = iMongoDb.pre();
      Login iLogin = new Login();
      iLogin.pre(rMongoDb);
      delete(request, rMongoDb);
      iLogin.post();
      iMongoDb.post();
      return true;
    }

    return false;
  }
}
