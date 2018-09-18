// GENERATED CODE - DO NOT MODIFY BY HAND

part of model;

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserMgoSerializer implements Serializer<User> {
  final _mongoId = const MongoId();
  @override
  Map<String, dynamic> toMap(User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', _mongoId.serialize(model.id));
    setMapValue(ret, 'username', model.username);
    setMapValue(ret, 'password', model.password);
    setMapValue(ret, 'authorizationId', model.authorizationId);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = new User();
    obj.id = _mongoId.deserialize(map['_id'] as ObjectId);
    obj.username = map['username'] as String;
    obj.password = map['password'] as String;
    return obj;
  }
}
