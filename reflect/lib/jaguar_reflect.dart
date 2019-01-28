// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library jaguar_reflect;

import 'package:jaguar/jaguar.dart';
import 'reflect/reflect.dart';

export 'package:jaguar/jaguar.dart';
export 'reflect/reflect.dart';
export 'bind/bind.dart';

/// Reflects the given [api] and returns an instance of [ReflectedController]
List<Route> reflect(Object api) => ReflectedController(api).routes;
