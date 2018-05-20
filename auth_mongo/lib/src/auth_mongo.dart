// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar.auth.mongo;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:jaguar/jaguar.dart';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';

class MgoUserManager<ModelType extends PasswordUser>
    implements AuthModelManager<ModelType> {
  final String collection;

  final List<String> fieldNames;

  final Serializer<ModelType> serializer;

  final Hasher hasher;

  MgoUserManager(this.serializer,
      {Hasher hasher,
      this.collection: 'user',
      this.fieldNames: const ['username']})
      : hasher = hasher ?? const NoHasher();

  Future<ModelType> fetchByAuthorizationId(Context ctx, String userId) async {
    final Db db = ctx.getInterceptorResult<Db>(MongoDb);
    final DbCollection col = db.collection(collection);
    Map map = await col.findOne(mgo.where.id(mgo.ObjectId.parse(userId)));
    return serializer.fromMap(map);
  }

  Future<ModelType> fetchByAuthenticationId(Context ctx, String authId) async {
    final Db db = ctx.getInterceptorResult<Db>(MongoDb);
    final DbCollection col = db.collection(collection);

    for (String fieldName in fieldNames) {
      Map map = await col.findOne(mgo.where.eq(fieldName, authId));
      if (map == null) continue;
      return serializer.fromMap(map);
    }

    return null;
  }

  Future<ModelType> authenticate(
      Context ctx, String userId, String password) async {
    ModelType model = await fetchByAuthenticationId(ctx, userId);

    if (model == null) {
      return null;
    }

    if (!hasher.verify(password, model.password)) {
      return null;
    }

    return model;
  }
}
