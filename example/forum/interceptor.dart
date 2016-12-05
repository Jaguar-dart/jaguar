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

class MongoDbState {
  final String whatever;

  const MongoDbState({this.whatever});
}

class MongoDb extends Interceptor {
  final String dbName;

  final MongoDbState state;

  const MongoDb(this.dbName, {String id, this.state}) : super(id: id);

  static MongoDbState createState() => new MongoDbState();

  Future<Db> pre() async {
    return new Db();
  }
}

class LoginState {
  final String whatever;

  const LoginState({this.whatever});
}

class Login extends Interceptor {
  final LoginState state;

  const Login([this.state]);

  @Input(MongoDb, id: 'Admin')
  void pre(Db db) {}
}

class EncodeToJson {
  const EncodeToJson();

  @InputRouteResponse()
  Response post(HttpRequest request, Response resp) {
    if (resp.value is ViewSerializer) {
      resp.value = JSON.encode(resp.value.toViewMap());
    } else {
      resp.value = '{}'; //TODO throw exception?
    }

    return resp;
  }
}
