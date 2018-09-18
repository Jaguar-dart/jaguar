library model;

import 'package:jaguar_example_session_models/jaguar_example_session_models.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:jaguar_common/jaguar_common.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_serializer_mongo/jaguar_serializer_mongo.dart';

part 'model.jser.dart';

@GenSerializer(fields: const {
  'id': const EnDecode(alias: '_id', processor: const MongoId()),
})
class UserMgoSerializer extends Serializer<User> with _$UserMgoSerializer {}

final UserMgoSerializer userMgoSerializer = UserMgoSerializer();
