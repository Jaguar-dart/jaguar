library example.interceptors.login;

import 'package:jaguar/jaguar.dart';

import 'db.dart';

class PasswordChecker {
  const PasswordChecker();
}

class Passwords {
  final Map<String, String> passwords = const {
    'user1': 'password1',
  };

  const Passwords();
}

class Login extends Interceptor {
  final PasswordChecker checker;

  final Passwords state;

  const Login(this.checker, {this.state});

  @Input(MongoDb, id: 'Admin')
  void pre(Db db) {}
}
