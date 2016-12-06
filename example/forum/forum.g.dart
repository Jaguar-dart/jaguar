// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.forum;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ForumApi
// **************************************************************************

abstract class _$JaguarForumApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(
        path: '/user',
        methods: const <String>['GET'],
        statusCode: 201,
        headers: const {"sample-header": "made-with.jaguar"}),
    const Route(path: '/user', methods: const <String>['POST']),
    const Route(path: '/user/:param1', methods: const <String>['PUT']),
    const Route(path: '/user1', methods: const <String>['PUT']),
    const Route(path: '/user2', methods: const <String>['PUT']),
    const Put(path: '/user3'),
    const Route(
        path: '/regex/:param1',
        methods: const <String>['PUT'],
        pathRegEx: const {'param1': r'^(hello|fello)$'}),
    const Route(path: '/regexrem/:param1*', methods: const <String>['PUT']),
    const Route(
        path: '/test/decodebody/formdata', methods: const <String>['POST']),
    const Route(path: '/test/decodebody/xwww', methods: const <String>['POST'])
  ];

  Future<User> fetch();

  User create(HttpRequest request, Db db,
      {String email, String name, String password, int age});

  String update(HttpRequest request, Db db, String param1,
      {int param2: 5555, int param3: 55});

  Response<User> update1(HttpRequest request, Db db, PathParams pathParams);

  Response<User> update2(HttpRequest request, Db db, ParamCreate pathParams);

  Future<Response<User>> update3(
      HttpRequest request, Db db, ParamCreate pathParams);

  Future<String> regex(HttpRequest request, Db db, String param1);

  Future<String> pathRem(HttpRequest request, Db db, String param1);

  String decodeFormData(Map<String, FormField> formFields);

  String decodeXwww(Map<String, String> xwww);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for fetch
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbTest = new MongoDb(
        'test',
        id: 'Test',
        state: MongoDb.createState(),
      );
      await iMongoDbTest.pre();
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
        state: const Passwords(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 201;
      rRouteResponse.headers['sample-header'] = 'made-with.jaguar';
      rRouteResponse.value = await fetch();
      await iMongoDbAdmin.post();
      await iMongoDbTest.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for create
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = create(
        request,
        rMongoDbAdmin,
        email: (queryParams.getField('email')),
        name: (queryParams.getField('name')),
        password: (queryParams.getField('password')),
        age: stringToInt(queryParams.getField('age')),
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for update
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = update(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
        param2: stringToInt(queryParams.getField('param2')) ?? 5555,
        param3: stringToInt(queryParams.getField('param3')) ?? 55,
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for update1
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse = update1(
        request,
        rMongoDbAdmin,
        null,
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for update2
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse = update2(
        request,
        rMongoDbAdmin,
        new ParamCreate.FromPathParam(pathParams),
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for update3
    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse = await update3(
        request,
        rMongoDbAdmin,
        new ParamCreate.FromPathParam(pathParams),
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for regex
    match =
        routes[6].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = await regex(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for pathRem
    match =
        routes[7].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin = new MongoDb(
        'admin',
        id: 'Admin',
        state: MongoDb.createState(),
      );
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login(
        const PasswordChecker(),
      );
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = await pathRem(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
      );
      await iMongoDbAdmin.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for decodeFormData
    match =
        routes[8].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      DecodeFormData iDecodeFormData = new DecodeFormData();
      Map<String, FormField> rDecodeFormData = await iDecodeFormData.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = decodeFormData(
        rDecodeFormData,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for decodeXwww
    match =
        routes[9].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      DecodeUrlEncodedForm iDecodeUrlEncodedForm = new DecodeUrlEncodedForm();
      Map<String, String> rDecodeUrlEncodedForm =
          await iDecodeUrlEncodedForm.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = decodeXwww(
        rDecodeUrlEncodedForm,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
