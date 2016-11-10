library example.forum;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'interceptor.dart';

part 'forum.g.dart';

class ParamValidationException {
  final int statusCode;

  final String param;

  final String error;

  ParamValidationException(this.statusCode, this.param, this.error);

  String toString() => 'ParamException($statusCode, $param)';
}

class ParamValidationExceptionHandler
    implements ExceptionHandler<ParamValidationException> {
  const ParamValidationExceptionHandler();

  void onRouteException(
      HttpRequest request, ParamValidationException e, StackTrace trace) {
    request.response.statusCode = e.statusCode;

    request.response
        .write('{"Code": 5, "Params": {"${e.param}: ${e.error} } }');
  }
}

class ParamCreate implements Validatable {
  PathParams _map;

  ParamCreate.FromPathParam(this._map) {
    _email = _map.email;
    _name = _map.name;
    _age = _map.getFieldAsInt('age');
  }

  String _email;

  String _name;

  int _age;

  String get email => _email;

  String get name => _name;

  int get age => _age;

  void validate() {
    if (_email is! String) {
      throw new Exception("No email provided!");
    }

    if (_name is! String) {
      throw new Exception("No name provided!");
    }

    if (_age is! int) {
      throw new Exception("No name provided!");
    }
  }
}

@Api(path: '/api')
class ForumApi extends Object with _$JaguarForumApi {
  @Route('/user',
      methods: const <String>['GET'],
      statusCode: 201,
      headers: const {"sample-header": "made-with.jaguar"})
  @MongoDb('test', id: 'Test', state: const MongoDbState())
  @MongoDb('admin', id: 'Admin')
  @Login(const LoginState())
  @EncodeToJson()
  Future<User> fetch() async {
    return new User('dummy@dummy.com', 'Dummy', 'password', 27);
  }

  @Route('/user', methods: const <String>['DELETE'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  void delete(HttpRequest request, Db db) {}

  @Route('/user/:param1', methods: const <String>['POST'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  User create(HttpRequest request, Db db, String email, String name,
      String password, int age) {
    return new User(email, name, password, age);
  }

  @Route('/user', methods: const <String>['PUT'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  String update(HttpRequest request, Db db, String param1,
      {int param2: 5555, int param3: 55}) {
    return param1;
  }

  @Route('/user1', methods: const <String>['PUT'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  @EncodeToJson()
  Response<User> update1(HttpRequest request, Db db, PathParams pathParams) {
    User user =
        new User(pathParams.email, pathParams.name, "password", pathParams.age);
    return new Response<User>(user);
  }

  @Route('/user2', methods: const <String>['PUT'], validatePathParams: true)
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  @ParamValidationExceptionHandler()
  Response<User> update2(HttpRequest request, Db db, ParamCreate pathParams) {
    User user =
        new User(pathParams.email, pathParams.name, "password", pathParams.age);
    return new Response<User>(user);
  }

  @Put('/user3', validatePathParams: true)
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  @ParamValidationExceptionHandler()
  @EncodeToJson()
  Future<Response<User>> update3(
      HttpRequest request, Db db, ParamCreate pathParams) async {
    User user =
        new User(pathParams.email, pathParams.name, "password", pathParams.age);
    return new Response<User>(user);
  }

  @Route('/regex/:param1',
      methods: const <String>['PUT'],
      validatePathParams: true,
      pathRegEx: const {'param1': r'^(hello|fello)$'})
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  Future<String> regex(HttpRequest request, Db db, String param1) async {
    return param1;
  }

  @Route('/regexrem/:param1*',
      methods: const <String>['PUT'], validatePathParams: true)
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  Future<String> pathRem(HttpRequest request, Db db, String param1) async {
    return param1;
  }

  @Route('/test/decodebody/json', methods: const <String>['POST'])
  @DecodeJson()
  @Input(DecodeJson)
  String decodeJson(Map<String, dynamic> json) {
    return json.toString();
  }

  @Route('/test/decodebody/formdata', methods: const <String>['POST'])
  @DecodeFormData()
  @Input(DecodeFormData)
  String decodeFormData(Map<String, FormField> formFields) {
    return formFields.toString();
  }

  @Route('/test/decodebody/xwww', methods: const <String>['POST'])
  @DecodeUrlEncodedForm()
  @Input(DecodeUrlEncodedForm)
  String decodeXwww(Map<String, String> xwww) {
    return xwww.toString();
  }
}
