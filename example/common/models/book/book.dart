library jwt_auth.example.models;

import 'dart:convert';

/// Model for Book
class Book {
  Book();

  Book.make(this.id, this.name, this.authors);

  Book.fromMap(Map map) {
    if (map['name'] is String) {
      name = map['name'];
    }

    if (map['authors'] is List) {
      List<String> value = map['authors'] as List<String>;
      if (value.every((el) => el is String)) {
        authors = value;
      }
    }
  }

  /// Id of the book
  String id;

  /// Name of the book
  String name;

  /// Authors of the book
  List<String> authors;

  /// Converts to Map
  Map toMap() => {
        'name': name,
        'authors': authors.toList(),
      };

  // Converts to JSON
  String toJson() {
    return JSON.encode(toMap());
  }

  void validate() {
    if (id is! String) {
      throw new Exception('Id is Required!');
    }

    if (id.isEmpty) {
      throw new Exception('Id must not be empty!');
    }

    if (name is! String) {
      throw new Exception('Name is required!');
    }

    if (name.isEmpty) {
      throw new Exception('Name must not be empty!');
    }

    if (authors is! List<String>) {
      throw new Exception('Authors is required!');
    }

    if (!authors.every((el) => el is String)) {
      throw new Exception('Authors is required!');
    }
  }
}
