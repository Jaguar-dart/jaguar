library example.forum.interceptor;

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'dart:convert';

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

class WrapEncodeObjectToJson implements RouteWrapper<EncodeObjectToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeObjectToJson({this.id});

  EncodeObjectToJson createInterceptor() => new EncodeObjectToJson();
}

class EncodeObjectToJson extends Interceptor {
  EncodeObjectToJson();

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
