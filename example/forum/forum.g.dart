// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.forum;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ForumApi
// **************************************************************************

abstract class _$JaguarForumApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route('/user',
        methods: const <String>['GET'],
        statusCode: 201,
        headers: const {"sample-header": "made-with.jaguar"}),
    const Route('/user', methods: const <String>['DELETE']),
    const Route('/user/:param1', methods: const <String>['POST']),
    const Route('/user', methods: const <String>['PUT']),
    const Route('/user1', methods: const <String>['PUT']),
    const Route('/user2', methods: const <String>['PUT']),
    const Put('/user3'),
    const Route('/regex/:param1',
        methods: const <String>['PUT'],
        pathRegEx: const {'param1': r'^(hello|fello)$'}),
    const Route('/regexrem/:param1*', methods: const <String>['PUT']),
    const Route('/test/decodebody/json', methods: const <String>['POST']),
    const Route('/test/decodebody/formdata', methods: const <String>['POST']),
    const Route('/test/decodebody/xwww', methods: const <String>['POST'])
  ];

  Future<User> fetch();

  void delete(HttpRequest request, Db db);

  User create(HttpRequest request, Db db, String email, String name,
      String password, int age);

  String update(HttpRequest request, Db db, String param1,
      {int param2: 5555, int param3: 55});

  Response<User> update1(HttpRequest request, Db db, PathParams pathParams);

  Response<User> update2(HttpRequest request, Db db, ParamCreate pathParams);

  Future<Response<User>> update3(
      HttpRequest request, Db db, ParamCreate pathParams);

  Future<String> regex(HttpRequest request, Db db, String param1);

  Future<String> pathRem(HttpRequest request, Db db, String param1);

  String decodeJson(Map<String, dynamic> json);

  String decodeFormData(Map<String, FormField> formFields);

  String decodeXwww(Map<String, String> xwww);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbTest = new MongoDb(
        'test',
        id: 'Test',
        state: const MongoDbState(),
      );
      await iMongoDbTest.pre();
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      EncodeToJson iEncodeToJson = new EncodeToJson();
      rRouteResponse.statusCode = 201;
      rRouteResponse.headers['sample-header'] = 'made-with.jaguar';
      rRouteResponse.value = await fetch();
      rRouteResponse = iEncodeToJson.post(
        request,
        rRouteResponse,
      );
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      rRouteResponse = await iMongoDbTest.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      delete(
        request,
        rMongoDbAdmin,
      );
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = create(
        request,
        rMongoDbAdmin,
        (pathParams.getField('email')),
        (pathParams.getField('name')),
        (pathParams.getField('password')),
        stringToInt(pathParams.getField('age')),
      );
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
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
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      EncodeToJson iEncodeToJson = new EncodeToJson();
      rRouteResponse = update1(
        request,
        rMongoDbAdmin,
        null,
      );
      rRouteResponse = iEncodeToJson.post(
        request,
        rRouteResponse,
      );
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      try {
        MongoDb iMongoDbAdmin =
            new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
        Db rMongoDbAdmin = await iMongoDbAdmin.pre();
        Login iLogin = new Login();
        iLogin.pre(
          rMongoDbAdmin,
        );
        rRouteResponse = update2(
          request,
          rMongoDbAdmin,
          new ParamCreate.FromPathParam(pathParams),
        );
        rRouteResponse = await iMongoDbAdmin.post(
          rRouteResponse,
        );
      } on ParamValidationException catch (e, s) {
        ParamValidationExceptionHandler handler =
            new ParamValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[6].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      try {
        MongoDb iMongoDbAdmin =
            new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
        Db rMongoDbAdmin = await iMongoDbAdmin.pre();
        Login iLogin = new Login();
        iLogin.pre(
          rMongoDbAdmin,
        );
        EncodeToJson iEncodeToJson = new EncodeToJson();
        rRouteResponse = await update3(
          request,
          rMongoDbAdmin,
          new ParamCreate.FromPathParam(pathParams),
        );
        rRouteResponse = iEncodeToJson.post(
          request,
          rRouteResponse,
        );
        rRouteResponse = await iMongoDbAdmin.post(
          rRouteResponse,
        );
      } on ParamValidationException catch (e, s) {
        ParamValidationExceptionHandler handler =
            new ParamValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[7].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = await regex(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
      );
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[8].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDbAdmin =
          new MongoDb('admin', id: 'Admin', state: MongoDb.createState());
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = await pathRem(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
      );
      rRouteResponse = await iMongoDbAdmin.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[9].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      DecodeJson iDecodeJson = new DecodeJson();
      dynamic rDecodeJson = await iDecodeJson.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = decodeJson(
        rDecodeJson,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    match =
        routes[10].match(request.uri.path, request.method, prefix, pathParams);
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

    match =
        routes[11].match(request.uri.path, request.method, prefix, pathParams);
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
