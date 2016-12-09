library example.forum;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'interceptor.dart';

import '../common/interceptors/db.dart';
import '../common/interceptors/login.dart';

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
  @Route(
      path: '/user',
      methods: const <String>['GET'],
      statusCode: 201,
      headers: const {"sample-header": "made-with.jaguar"})
  @WrapMongoDb(dbName: 'test', id: 'Test')
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker(), state: const Passwords())
  @WrapEncodeObjectToJson()
  Future<User> fetch() async {
    return new User('dummy@dummy.com', 'Dummy', 'password', 27);
  }

  @Route(path: '/user', methods: const <String>['POST'])
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @Input(MongoDb, id: 'Admin')
  User create(HttpRequest request, Db db,
      {String email, String name, String password, int age}) {
    return new User(email, name, password, age);
  }

  @Route(path: '/user/:param1', methods: const <String>['PUT'])
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @Input(MongoDb, id: 'Admin')
  String update(HttpRequest request, Db db, String param1,
      {int param2: 5555, int param3: 55}) {
    return param1;
  }

  @Route(path: '/user1', methods: const <String>['PUT'])
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @Input(MongoDb, id: 'Admin')
  @WrapEncodeObjectToJson()
  Response<User> update1(HttpRequest request, Db db, PathParams pathParams) {
    User user =
        new User(pathParams.email, pathParams.name, "password", pathParams.age);
    return new Response<User>(user);
  }

  @Route(path: '/user2', methods: const <String>['PUT'])
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @Input(MongoDb, id: 'Admin')
  @InputPathParams(true)
  Response<User> update2(HttpRequest request, Db db, ParamCreate pathParams) {
    User user =
        new User(pathParams.email, pathParams.name, "password", pathParams.age);
    return new Response<User>(user);
  }

  @Put(path: '/user3')
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @WrapEncodeObjectToJson()
  @Input(MongoDb, id: 'Admin')
  @InputPathParams(true)
  Future<Response<User>> update3(
      HttpRequest request, Db db, ParamCreate pathParams) async {
    User user =
        new User(pathParams.email, pathParams.name, "password", pathParams.age);
    return new Response<User>(user);
  }

  @Route(
      path: '/regex/:param1',
      methods: const <String>['PUT'],
      pathRegEx: const {'param1': r'^(hello|fello)$'})
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @Input(MongoDb, id: 'Admin')
  Future<String> regex(HttpRequest request, Db db, String param1) async {
    return param1;
  }

  @Route(path: '/regexrem/:param1*', methods: const <String>['PUT'])
  @WrapMongoDb(dbName: 'admin', id: 'Admin')
  @Login(const PasswordChecker())
  @Input(MongoDb, id: 'Admin')
  Future<String> pathRem(HttpRequest request, Db db, String param1) async {
    return param1;
  }

  @Route(path: '/test/decodebody/formdata', methods: const <String>['POST'])
  @WrapDecodeFormData()
  @Input(DecodeFormData)
  String decodeFormData(Map<String, FormField> formFields) {
    return formFields.toString();
  }

  @Route(path: '/test/decodebody/xwww', methods: const <String>['POST'])
  @WrapDecodeUrlEncodedForm()
  @Input(DecodeUrlEncodedForm)
  String decodeXwww(Map<String, String> xwww) {
    return xwww.toString();
  }
}
