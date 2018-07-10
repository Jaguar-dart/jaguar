// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar.auth.mongo;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:jaguar/jaguar.dart';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_serializer/jaguar_serializer.dart';

class MgoUserManager<ModelType extends PasswordUser>
    implements UserFetcher<ModelType> {
  final String collection;

  final List<String> fieldNames;

  final Serializer<ModelType> serializer;

  MgoUserManager(this.serializer,
      {this.collection: 'user', this.fieldNames: const ['username']});

  Future<ModelType> byAuthorizationId(Context ctx, String userId) async {
    final Db db = ctx.getVariable<Db>();
    final DbCollection col = db.collection(collection);
    Map map = await col.findOne(mgo.where.id(mgo.ObjectId.parse(userId)));
    return serializer.fromMap(map);
  }

  Future<ModelType> byAuthenticationId(Context ctx, String authId) async {
    final Db db = ctx.getVariable<Db>();
    final DbCollection col = db.collection(collection);

    for (String fieldName in fieldNames) {
      Map map = await col.findOne(mgo.where.eq(fieldName, authId));
      if (map == null) continue;
      return serializer.fromMap(map);
    }

    return null;
  }
}
