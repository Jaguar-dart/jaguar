// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar.throttle;

import 'dart:math';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_cache/jaguar_cache.dart';

part 'bookkeep.dart';
part 'interceptor.dart';
part 'rate.dart';
part 'state.dart';

/// Identifies a HTTP request given the [Context] object
///
/// For example identifier could be based on
///   1. IP address
///   2. Logged-in User
///   3. Session id
///   4. route
///   5. Etc
///   6. Or any combination of the above
typedef FutureOr<String> ThrottleIdMaker(Context ctx);

/// [ThrottleIdMaker] to throttle requests by remote IP
String throttleIdByIp(Context ctx) =>
    ctx.req.connectionInfo.remoteAddress.address;

/// Throttles for given [id] with [quota]
Future<ThrottleState> throttle(String id, Rate quota, {Cache store}) async {
  store ??= defaultThrottleCache;
  final ThrottleData count = await _visit(id, quota.interval, store);

  final state = new ThrottleState.make(quota.count, count, quota.interval);

  if (count == null) return state;

  if (count.count > quota.count) throw state;

  return state;
}

final Cache defaultThrottleCache = new InMemoryCache(new Duration(seconds: -1));

Future<ThrottleData> _visit(
    String identifier, Duration interval, Cache store) async {
  ThrottleData ret = new ThrottleData.now(1);

  ThrottleData data;

  try {
    data = await store.read(identifier);
  } catch (e) {
    if (e != cacheMiss) rethrow;
  }

  final now = new DateTime.now();

  if (data == null)
    ret = new ThrottleData.now(1);
  else if (now.difference(data.time()) < interval)
    ret = data.inc(data.milliseconds);
  else
    ret = new ThrottleData.now(1);

  await store.upsert(identifier, ret);
  return ret;
}
