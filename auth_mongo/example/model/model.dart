library model;

import 'package:jaguar_common/jaguar_common.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_serializer_mongo/jaguar_serializer_mongo.dart';

part 'model.g.dart';

/// Model for Book
class Book {
  /// Id of the book
  String id;

  /// Name of the book
  String name;

  /// Authors of the book
  String author;

  Book();

  Book.make(this.id, this.name, this.author);
}

@GenSerializer()
class BookSerializer extends Serializer<Book> with _$BookSerializer {
  Book createModel() => new Book();
}

class User implements PasswordUser {
  String id;

  String username;

  String password;

  User();

  User.make(this.id, this.username, this.password);

  String get authorizationId => id;
}

@GenSerializer(ignore: const ['loginId', 'loginPassword', 'authorizationId'])
class UserSerializer extends Serializer<User> with _$UserSerializer {
  User createModel() => new User();
}

@GenSerializer(fields: const {
  'id': const EnDecode(alias: '_id', processor: const MongoId()),
})
class UserMgoSerializer extends Serializer<User> with _$UserMgoSerializer {
  User createModel() => new User();
}

final BookSerializer bookSerializer = new BookSerializer();

final UserSerializer userSerializer = new UserSerializer();

final UserMgoSerializer userMgoSerializer = new UserMgoSerializer();
