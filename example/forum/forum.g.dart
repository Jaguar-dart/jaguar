// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.forum;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ForumApi
// **************************************************************************

abstract class _$JaguarForumApi implements ApiInterface {
  static const List<Route> _routes = const <Route>[
    const Route('/user',
        methods: const <String>['GET'],
        statusCode: 201,
        headers: const {"sample-header": "made-with.jaguar"}),
    const Route('/user', methods: const <String>['DELETE']),
    const Route('/user/:param1', methods: const <String>['POST']),
    const Route('/user', methods: const <String>['PUT']),
    const Route('/user1', methods: const <String>['PUT']),
    const Route('/user2',
        methods: const <String>['PUT'], validatePathParams: true),
    const Route('/user3',
        methods: const <String>['PUT'], validatePathParams: true),
    const Route('/regex/:param1',
        methods: const <String>['PUT'],
        validatePathParams: true,
        pathRegEx: const {'param1': r'^(hello|fello)$'}),
    const Route('/regexrem/:param1*',
        methods: const <String>['PUT'], validatePathParams: true),
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

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams();
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);
    bool match = false;

    match =
        _routes[0].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbTest = new MongoDb('test', id: 'Test');
      await iMongoDbTest.pre();
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      EncodeToJson iEncodeToJson = new EncodeToJson();
      User rRouteResponse;
      rRouteResponse = await fetch();
      request.response.statusCode = 201;
      request.response.headers.add("sample-header", "made-with.jaguar");
      iEncodeToJson.post(
        request,
        rRouteResponse,
      );
      await iMongoDbAdmin.post();
      await iMongoDbTest.post();
      return true;
    }

    match =
        _routes[1].match(request.uri.path, request.method, '/api', pathParams);
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
      request.response.statusCode = 200;
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[2].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      User rRouteResponse;
      rRouteResponse = create(
        request,
        rMongoDbAdmin,
        (pathParams.getField('email')),
        (pathParams.getField('name')),
        (pathParams.getField('password')),
        stringToInt(pathParams.getField('age')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[3].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      String rRouteResponse;
      rRouteResponse = update(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
        param2: stringToInt(queryParams.getField('param2')) ?? 5555,
        param3: stringToInt(queryParams.getField('param3')) ?? 55,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[4].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      EncodeToJson iEncodeToJson = new EncodeToJson();
      Response<User> rRouteResponse;
      PathParams injectPathParam = new PathParams.FromPathParam(pathParams);
      rRouteResponse = update1(
        request,
        rMongoDbAdmin,
        injectPathParam,
      );
      request.response.statusCode = rRouteResponse.statusCode ?? 200;
      if (rRouteResponse.headers is Map) {
        for (String key in rRouteResponse.headers.keys) {
          request.response.headers.add(key, rRouteResponse.headers[key]);
        }
      }
      iEncodeToJson.post(
        request,
        rRouteResponse.value,
      );
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[5].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      Response<User> rRouteResponse;
      try {
        ParamCreate injectPathParam = new ParamCreate.FromPathParam(pathParams);
        if (injectPathParam is Validatable) {
          injectPathParam.validate();
        }
        rRouteResponse = update2(
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
      request.response.statusCode = rRouteResponse.statusCode ?? 200;
      if (rRouteResponse.headers is Map) {
        for (String key in rRouteResponse.headers.keys) {
          request.response.headers.add(key, rRouteResponse.headers[key]);
        }
      }
      request.response.write(rRouteResponse.valueAsString);
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[6].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      EncodeToJson iEncodeToJson = new EncodeToJson();
      Response<User> rRouteResponse;
      ParamCreate injectPathParam = new ParamCreate.FromPathParam(pathParams);
      if (injectPathParam is Validatable) {
        injectPathParam.validate();
      }
      rRouteResponse = await update3(
        request,
        rMongoDbAdmin,
        injectPathParam,
      );
      request.response.statusCode = rRouteResponse.statusCode ?? 200;
      if (rRouteResponse.headers is Map) {
        for (String key in rRouteResponse.headers.keys) {
          request.response.headers.add(key, rRouteResponse.headers[key]);
        }
      }
      iEncodeToJson.post(
        request,
        rRouteResponse.value,
      );
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[7].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      String rRouteResponse;
      rRouteResponse = await regex(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[8].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      MongoDb iMongoDbAdmin = new MongoDb('admin', id: 'Admin');
      Db rMongoDbAdmin = await iMongoDbAdmin.pre();
      Login iLogin = new Login();
      iLogin.pre(
        rMongoDbAdmin,
      );
      String rRouteResponse;
      rRouteResponse = await pathRem(
        request,
        rMongoDbAdmin,
        (pathParams.getField('param1')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      await iMongoDbAdmin.post();
      return true;
    }

    match =
        _routes[9].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      DecodeJson iDecodeJson = new DecodeJson();
      dynamic rDecodeJson = await iDecodeJson.pre(
        request,
      );
      String rRouteResponse;
      rRouteResponse = decodeJson(
        rDecodeJson,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[10].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      DecodeFormData iDecodeFormData = new DecodeFormData();
      Map<String, FormField> rDecodeFormData = await iDecodeFormData.pre(
        request,
      );
      String rRouteResponse;
      rRouteResponse = decodeFormData(
        rDecodeFormData,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[11].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      DecodeUrlEncodedForm iDecodeUrlEncodedForm = new DecodeUrlEncodedForm();
      Map<String, String> rDecodeUrlEncodedForm =
          await iDecodeUrlEncodedForm.pre(
        request,
      );
      String rRouteResponse;
      rRouteResponse = decodeXwww(
        rDecodeUrlEncodedForm,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}
