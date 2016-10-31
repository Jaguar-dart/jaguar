library example.forum.interceptor;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'dart:convert';

class Db {}

abstract class ViewSerializer {
  void fromViewMap(Map map);

  Map toViewMap();
}

abstract class ModelSerializer {
  void fromModelMap(Map map);

  Map toModelMap();
}

class User implements ViewSerializer, ModelSerializer {
  User(this.email, this.name, this.passwordHash, this.age);

  String email;

  String name;

  String passwordHash;

  int age;

  String toString() => JSON.encode(toMap());

  Map toMap() => {
        "email": email,
        "name": name,
        "age": age,
      };

  void fromMap(Map map) {
    email = map['email'];
    name = map['name'];
    age = map['age'];
  }

  void fromViewMap(Map map) => fromMap(map);

  Map toViewMap() => toMap();

  void fromModelMap(Map map) {
    fromMap(map);

    passwordHash = map['pwdH'];
  }

  Map toModelMap() => toMap()..['pwdH'] = passwordHash;
}

@InterceptorClass()
class MongoDb extends Interceptor {
  final String dbName;

  const MongoDb(this.dbName, {String id}) : super(id: id);

  Future<Db> pre() async {
    return new Db();
  }

  Future post() async {}
}

@InterceptorClass()
class Login extends Interceptor {
  const Login();

  @Input(MongoDb, id: 'Admin')
  void pre(Db db) {}
}

@InterceptorClass(writesResponse: true)
class EncodeToJson {
  const EncodeToJson();

  @Input(RouteResponse)
  void post(HttpRequest request, ViewSerializer result) {
    request.response.write(JSON.encode(result.toViewMap()));
  }
}
