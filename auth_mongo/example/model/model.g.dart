// GENERATED CODE - DO NOT MODIFY BY HAND

part of model;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class BookSerializer
// **************************************************************************

abstract class _$BookSerializer implements Serializer<Book> {
  Map toMap(Book model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.author != null) {
        ret["author"] = model.author;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  Book fromMap(Map map, {Book model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Book) {
      model = createModel();
    }
    model.id = map["id"];
    model.name = map["name"];
    model.author = map["author"];
    return model;
  }

  String modelString() => "Book";
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class UserSerializer
// **************************************************************************

abstract class _$UserSerializer implements Serializer<User> {
  Map toMap(User model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.username != null) {
        ret["username"] = model.username;
      }
      if (model.password != null) {
        ret["password"] = model.password;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  User fromMap(Map map, {User model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! User) {
      model = createModel();
    }
    model.id = map["id"];
    model.username = map["username"];
    model.password = map["password"];
    return model;
  }

  String modelString() => "User";
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class UserMgoSerializer
// **************************************************************************

abstract class _$UserMgoSerializer implements Serializer<User> {
  final MongoId idMongoId = const MongoId();

  Map toMap(User model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["_id"] = idMongoId.serialize(model.id);
      }
      if (model.username != null) {
        ret["username"] = model.username;
      }
      if (model.password != null) {
        ret["password"] = model.password;
      }
      if (model.authorizationId != null) {
        ret["authorizationId"] = model.authorizationId;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  User fromMap(Map map, {User model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! User) {
      model = createModel();
    }
    model.id = idMongoId.deserialize(map["_id"]);
    model.username = map["username"];
    model.password = map["password"];
    return model;
  }

  String modelString() => "User";
}
