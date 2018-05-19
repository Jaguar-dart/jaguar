library auth.example.models;

import 'package:jaguar_common/jaguar_common.dart';

/// Model for Book
class Book {
  String id, name;
  Book({this.id, this.name});
  static  Book fromJson(Map map) =>
      new Book(id: map['id'], name: map['name']);
  String toString() => 'Book(id: $id, name: $name)';
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class User implements AuthorizationUser {
  String id, username, password;
  User({this.id, this.username, this.password});
  static User fromJson(Map map) => new User(
      id: map['id'], username: map['username'], password: map['password']);
  String get authorizationId => id;
  String toString() => 'User(id: $id, username: $username)';
  Map<String, dynamic> toJson() => {'id':id, 'username': username};
}
