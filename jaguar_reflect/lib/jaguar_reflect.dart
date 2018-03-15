// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library jaguar_reflect;

import 'src/reflect.dart';

export 'src/reflect.dart';
export 'src/bootstrap.dart';

/// Reflects the given [api] and returns an instance of [ReflectedApi]
ReflectedApi reflect(Object api) => new ReflectedApi(api);
