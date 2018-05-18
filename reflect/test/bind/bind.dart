import 'dart:async';
import 'package:jaguar/jaguar.dart';

class InjectParam {
  final String name;
  const InjectParam([this.name]);
}

class JsonBody<T> {
  const JsonBody();
}

abstract class Action<T> implements RequestHandler {
  FutureOr<void> handleRequest(Context ctx, {String prefix}) {
    // TODO
  }

  FutureOr<T> run(Context ctx);
}

class User {
  String name;

  String email;

  User({this.name, this.email});

  static User fromJson(Map map) =>
      new User(name: map['name'], email: map['email']);
}

abstract class GetUserSpec {
  @InjectParam()
  String id;
}

class GetUser extends Action<User> with GetUserSpec {
  @InjectParam()
  String id;

  @Get(path: '/user')
  User run(Context ctx) {
    // TODO
  }
}

class CreateUser extends Action<User> {
  @JsonBody()
  User user;

  User run(Context ctx) {
    // TODO
  }
}

class UpdateUser extends Action<User> {
  @InjectParam()
  String id;

  @JsonBody()
  User user;

  User run(Context ctx) {
    // TODO
  }
}

main() {
  // TODO
}
