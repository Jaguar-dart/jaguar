// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library jaguar_reflect;

import 'reflect/reflect.dart';

export 'reflect/reflect.dart';

/// Reflects the given [api] and returns an instance of [ReflectedController]
ReflectedController reflect(Object api) => new ReflectedController(api);
