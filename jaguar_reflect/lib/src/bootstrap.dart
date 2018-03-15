library bootstrap;

import 'dart:mirrors';

import 'package:dice/dice.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart' as ref;

/// Detects root [Api]s and add them to provided [server]
///
/// If provided, [injector] is used as DI to instantiate the [Api] classes
void bootstrap(Jaguar server, {List<Symbol> filter, Injector injector}) {
  final scanner = new _Scanner(filter);

  final Set<ClassMirror> apis = scanner.scan();

  for (final ClassMirror cm in apis) {
    final MethodMirror constructor = cm.declarations[cm.simpleName];
    if (constructor is! MethodMirror)
      throw new Exception("Bootstrap requires unnamed constructor!");
    var api;
    if (constructor.parameters.length == 0) {
      api = cm.newInstance(new Symbol(''), []).reflectee;
    } else {
      if (injector == null)
        throw new Exception(
            "Bootstrap requires injector to instantiate constructor with parameters!");
      api = _fromDi(cm, constructor, injector);
    }
    server.addApi(_mkHandler(cm, api));
  }
}

/// Annotation to ignore searching in libraries or ignore specific class
const _Ignore ignore = const _Ignore();

class _Ignore {
  const _Ignore();
}

//do not scan the following libraries
const List<Symbol> blacklist = const [
  #dart.core,
  #dart.async,
  #dart.collection,
  #dart.convert,
  #dart.html,
  #dart.indexed_db,
  #dart.io,
  #dart.isolate,
  #dart.js,
  #dart.math,
  #dart.mirrors,
  #dart.svg,
  #dart.typed_data,
  #dart.web_audio,
  #dart.web_gl,
  #dart.web_sql
];

final _blacklistSet = new Set<Symbol>.from(blacklist);

class _Scanner {
  final List<Symbol> filter;

  Set<String> _libCache = new Set();

  _Scanner([this.filter]);

  Set<ClassMirror> scan() {
    final MirrorSystem mirrorSystem = currentMirrorSystem();
    final roots = new Set<LibraryMirror>();

    if (filter != null) {
      roots.addAll(filter.map(mirrorSystem.findLibrary));
    } else {
      roots.add(mirrorSystem.isolate.rootLibrary);
    }

    final libraries = new Set<LibraryMirror>();
    libraries.addAll(roots);
    roots.map(_collectLibrary).forEach(libraries.addAll);

    final apis = new Set<ClassMirror>();
    libraries.map(_findHandlers).forEach(apis.addAll);

    return apis;
  }

  bool canSearchLibrary(LibraryDependencyMirror dep) {
    // Ignore exports
    if (!dep.isImport) return false;

    // Ignore black listed libraries
    return !_blacklistSet.contains(dep.targetLibrary.simpleName);
  }

  Set<LibraryMirror> _collectLibrary(LibraryMirror mirror) {
    final ret = new Set<LibraryMirror>();

    for (final LibraryDependencyMirror dep in mirror.libraryDependencies) {
      if (!canSearchLibrary(dep)) continue;

      // If the library is already searched, dont search it again
      if (_libCache.contains(dep.targetLibrary.uri.path)) continue;
      _libCache.add(dep.targetLibrary.uri.path);

      if (dep.metadata.any(_isIgnored)) continue;

      ret.add(dep.targetLibrary);
      ret.addAll(_collectLibrary(dep.targetLibrary));
    }

    return ret;
  }

  bool _isIgnored(InstanceMirror im) => im.reflectee is _Ignore;

  bool _isApi(InstanceMirror im) => im.reflectee is Api;

  Set<ClassMirror> _findHandlers(LibraryMirror lib) {
    final apis = new Set<ClassMirror>();
    for (final DeclarationMirror declaration in lib.declarations.values) {
      if (declaration is! ClassMirror) continue;

      if (declaration.metadata.any(_isIgnored)) continue;

      if (declaration.metadata.length == 0) continue;

      final api = declaration.metadata
          .firstWhere((InstanceMirror im) => _isApi(im), orElse: null);
      if (api == null) continue;
      final bool isRoot = api.getField(#isRoot).reflectee;
      if (!isRoot) continue;

      apis.add(declaration);
    }
    return apis;
  }
}

RequestHandler _mkHandler(ClassMirror cm, api) {
  final LibraryMirror owner = cm.owner;
  DeclarationMirror jdm = owner
      .declarations[new Symbol('Jaguar' + MirrorSystem.getName(cm.simpleName))];
  if (jdm is! ClassMirror) return ref.reflect(api);
  ClassMirror jcm = jdm as ClassMirror;
  if (jdm.metadata.where((im) => im.reflectee is _Ignore).length != 0)
    return ref.reflect(api);
  return jcm.newInstance(new Symbol(''), [api]).reflectee;
}

dynamic _fromDi(ClassMirror cm, MethodMirror constructor, Injector injector) {
  final posArgs = [];
  final namedArgs = <Symbol, dynamic>{};
  for (ParameterMirror param in constructor.parameters) {
    if (!param.isOptional || !param.isNamed) {
      //TODO check for @inject
      InstanceMirror nm = param.metadata.firstWhere(
          (InstanceMirror im) => im.reflectee is Named,
          orElse: null);
      posArgs.add(injector.getInstance(param.type.reflectedType,
          named: nm?.reflectee?.name));
    }
  }
  return cm
      .newInstance(constructor.constructorName, posArgs, namedArgs)
      .reflectee;
}
