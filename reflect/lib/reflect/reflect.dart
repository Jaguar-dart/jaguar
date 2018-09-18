// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar.reflect;

import 'package:jaguar/jaguar.dart';
import 'dart:mirrors';
import 'dart:collection';

/// Composing routes are parsed by reflecting the provided [_api]. Alternative
/// is to to source generate.
class ReflectedController {
  /// The api instance being reflected
  final Controller _api;

  /// Routes parsed from [_api]
  final _routes = <Route>[];

  /// The composing routes.
  ///
  /// Publicly exposes an immutable version of [_routes]
  UnmodifiableListView<Route> get routes =>
      UnmodifiableListView<Route>(_routes);

  /// Constructs a
  ReflectedController(this._api) {
    _parseController();
  }

  void _parseController() {
    final InstanceMirror im = reflect(_api);

    GenController api = _getAnnotation<GenController>(im.type.metadata);
    if (api == null)
      throw Exception(
          'Handler is not decorated with GenController annotation!');

    _parse(im, api.path);
  }

  void _parse(InstanceMirror im, String pathPrefix) {
    for (DeclarationMirror decl in im.type.declarations.values) {
      if (decl.isPrivate) continue;

      // Collect IncludeApi
      if (decl is VariableMirror) {
        _parseGroup(pathPrefix, decl, im.getField(decl.simpleName));
        continue;
      }

      // Collect routes
      if (decl is MethodMirror) {
        _parseRoute(im, pathPrefix, decl);
        continue;
      }
    }
  }

  void _parseGroup(String pathPrefix, VariableMirror decl, InstanceMirror gim) {
    final IncludeController group =
        _getAnnotation<IncludeController>(decl.metadata);

    if (group == null) return;

    if (!decl.isFinal) throw Exception('IncludeApi must be final!');

    if (gim.reflectee == null) throw Exception('Group cannot be null!');

    GenController rg = _getAnnotation<GenController>(gim.type.metadata);

    if (rg == null) throw Exception('Included API must be annotated with Api!');

    _parse(gim, pathPrefix + group.path + rg.path);
    return;
  }

  void _parseRoute(InstanceMirror im, String pathPrefix, MethodMirror decl) {
    final List<HttpMethod> routes = decl.metadata
        .where((InstanceMirror annot) => annot.reflectee is HttpMethod)
        .map((InstanceMirror annot) => annot.reflectee)
        .toList()
        .cast<HttpMethod>();
    if (routes.length == 0) return;

    InstanceMirror method = im.getField(decl.simpleName);

    InstanceMirror before = im.getField(#before);

    for (HttpMethod route in routes) {
      final cloned = route.cloneWith(path: pathPrefix + route.path);
      final r = Route.fromInfo(cloned, method.reflectee,
          before: [before.reflectee as RouteInterceptor]);
      _routes.add(r);
    }
  }
}

T _getAnnotation<T>(List<InstanceMirror> annots) => annots
    .map((InstanceMirror aim) => aim.reflectee)
    .firstWhere((ref) => ref is T, orElse: () => null);
