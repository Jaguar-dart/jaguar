library jwt_auth.example.models;

/// Model for Book
class Book {
  Book();

  Book.make(this.id, this.name, this.authors);

  Book.fromMap(Map map) {
    name = map['name'];
    authors = (map['authors'] as List).cast<String>() ?? <String>[];
  }

  static Book map(Map map) => new Book.fromMap(map);

  /// Id of the book
  String id;

  /// Name of the book
  String name;

  /// Authors of the book
  List<String> authors;

  /// Converts to Map
  Map toJson() => {
        'name': name,
        'authors': authors.toList(),
      };

  String toString() => toJson().toString();
}
