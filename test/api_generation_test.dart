@TestOn('!browser')
library source_gen.test.json_generator_test;

import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:analyzer/src/string_source.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';
import 'package:test/test.dart';

import 'test_utils.dart';
import 'src/io.dart';

import 'package:jaguar/generator/hook/api/import.dart';
//TODO import 'package:jaguar/jaguar.dart';

const _generator = const ApiGenerator();

CompilationUnit _compUnit;

Future<Element> _getClassForCodeString(String name) async {
  if (_compUnit == null) {
    _compUnit = await _getCompilationUnitForString(getPackagePath());
  }

  return getElementsFromLibraryElement(_compUnit.element.library)
      .singleWhere((e) => e.name == name);
}

Future<CompilationUnit> _getCompilationUnitForString(String projectPath) async {
  Source source = new StringSource(_testSource, 'test content');

  var foundFiles = await getDartFiles(projectPath,
      searchList: [p.join(getPackagePath(), 'test', 'test_files')]);

  var context = await getAnalysisContextForProjectPath(projectPath, foundFiles);

  LibraryElement libElement = context.computeLibraryElement(source);
  return context.resolveCompilationUnit(source, libElement);
}

dynamic _getInstantiatedAnnotation(LibraryElement lib, String className) =>
    instantiateAnnotation(_getClassAnnotation(lib, className));

ElementAnnotation _getClassAnnotation(LibraryElement lib, String className) =>
    _getAnnotatedClass(lib, className).metadata.single;

ClassElement _getAnnotatedClass(LibraryElement lib, String className) =>
    lib.units
        .expand((cu) => cu.types)
        .singleWhere((cd) => cd.name == className);

Future<LibraryElement> _getTestLibElement() async {
  var testFilesRelativePath = p.join('test', 'test_files');

  var projectPath = getPackagePath();

  var foundFiles =
      await getDartFiles(projectPath, searchList: [testFilesRelativePath]);

  var context = await getAnalysisContextForProjectPath(projectPath, foundFiles);

  var annotatedClassesFilePath =
      p.join(projectPath, testFilesRelativePath, 'api_test_example.dart');

  return getLibraryElementForSourceFile(context, annotatedClassesFilePath);
}

const _testSource = r'''
import 'dart:async';
import 'dart:io';

import 'package:jaguar/interceptors.dart';

@Api()
class ApiWithoutParam {}

@Api(name: 'api')
class ApiWithName {}

@Api(version: 'v1')
class ApiWithVersion {}

@Api(name: 'api', version: 'v1')
class ApiWithNameAndVersion extends _$JaguarApiWithNameAndVersion {}

@Api()
class ApiWithoutParamWithSimpleRoute
    extends _$JaguarApiWithoutParamWithSimpleRoute {
  @Route(path: 'ping')
  void ping() {}
}

@Api()
class ApiWithoutParamWithSimpleRouteWithHttpRequest
    extends _$JaguarApiWithoutParamWithSimpleRouteWithHttpRequest {
  @Route(path: 'ping')
  void ping(HttpRequest request) {}
}

@Api()
class ApiWithoutParamWithFutureRoute
    extends _$JaguarApiWithoutParamWithFutureRoute {
  @Route(path: 'ping')
  Future<Null> ping() async {}
}

@Api()
class ApiWithoutParamWithFutureRouteWithHttpRequest
    extends _$JaguarApiWithoutParamWithFutureRouteWithHttpRequest {
  @Route(path: 'ping')
  Future<Null> ping(HttpRequest request) async {}
}

@Api(name: 'api')
class ApiWithNameWithSimpleRoute extends _$JaguarApiWithNameWithSimpleRoute {
  @Route(path: 'ping')
  void ping() {}
}

@Api(name: 'api', version: 'v1')
class ApiWithNameAndVersionWithSimpleRoute
    extends _$JaguarApiWithNameAndVersionWithSimpleRoute {
  @Route(path: 'ping')
  void ping() {}
}

class MyEmptyGroup {}

@Api()
class ApiWithGroup extends _$JaguarApiWithGroup {
  @Group(name: 'myGroup')
  MyEmptyGroup myGroup = new MyEmptyGroup();
}

class GroupWithOneRoute {
  @Route(path: 'ping')
  void ping() {}
}

@Api()
class ApiWithGroupWithSimpleRoute extends _$JaguarApiWithGroupWithSimpleRoute {
  @Group(name: 'myGroup')
  GroupWithOneRoute myGroup = new GroupWithOneRoute();
}

@Api()
class ApiAndRouteWithParam extends _$JaguarApiAndRouteWithParam {
  @Route(path: 'users/([a-zA-Z])')
  void ping(String id) {}
}

@Api()
class ApiAndRouteWithHttpRequestAndParam
    extends _$JaguarApiAndRouteWithHttpRequestAndParam {
  @Route(path: 'users/([a-zA-Z])')
  void ping(HttpRequest request, String id) {}
}

@Api()
class ApiAndRouteWithQueryParameter
    extends _$JaguarApiAndRouteWithQueryParameter {
  @Route(path: 'users')
  void ping({String name}) {}
}
''';

String getCodeForEmptyApi(String className) {
  return '''
abstract class $className {
List<RouteInformations> _routes = <RouteInformations>[
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
return false;
}

}
''';
}

const String codeForApiWithoutParamWithSimpleRoute = r'''
abstract class _$JaguarApiWithoutParamWithSimpleRoute {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping();
return true;
}
return false;
}

}
''';

const String codeForApiWithoutParamWithSimpleRouteAndWithHttpRequest = r'''
abstract class _$JaguarApiWithoutParamWithSimpleRouteWithHttpRequest {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping(request,);
return true;
}
return false;
}

}
''';

const String codeForApiWithoutParamWithFutureRoute = r'''
abstract class _$JaguarApiWithoutParamWithFutureRoute {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
await ping();
return true;
}
return false;
}

}
''';

const String codeForApiWithoutParamWithFutureRouteWithHttpRequest = r'''
abstract class _$JaguarApiWithoutParamWithFutureRouteWithHttpRequest {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
await ping(request,);
return true;
}
return false;
}

}
''';

const String codeForApiWithNameWithSimpleRoute = r'''
abstract class _$JaguarApiWithNameWithSimpleRoute {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping();
return true;
}
return false;
}

}
''';

const String codeForApiWithNameAndVersionWithSimpleRoute = r'''
abstract class _$JaguarApiWithNameAndVersionWithSimpleRoute {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/api/v1/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping();
return true;
}
return false;
}

}
''';

const String codeForApiWithGroup = r'''
abstract class _$JaguarApiWithGroup {
List<RouteInformations> _routes = <RouteInformations>[
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
return false;
}

}
''';

const String codeForApiWithGroupWithSimpleRoute = r'''
abstract class _$JaguarApiWithGroupWithSimpleRoute {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/myGroup/ping", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
myGroup.ping();
return true;
}
return false;
}

}
''';

const String codeForApiAndRouteWithParam = r'''
abstract class _$JaguarApiAndRouteWithParam {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/users/([a-zA-Z])", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping(args[0],);
return true;
}
return false;
}

}
''';

const String codeForApiAndRouteWithHttpRequestAndParam = r'''
abstract class _$JaguarApiAndRouteWithHttpRequestAndParam {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/users/([a-zA-Z])", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping(request,args[0],);
return true;
}
return false;
}

}
''';

const String codeForApiAndRouteWithQueryParameter = r'''
abstract class _$JaguarApiAndRouteWithQueryParameter {
List<RouteInformations> _routes = <RouteInformations>[
new RouteInformations(r"/users", ["GET","POST","PUT","PATCH","DELETE","OPTIONS"]),
];

Future<bool> handleApiRequest(HttpRequest request) async {
List<String> args = <String>[];
bool match = false;
match = _routes[0].matchWithRequestPathAndMethod(args, request.uri.path, request.method);
if (match) {
ping(name: request.uri.queryParameters['name'],);
return true;
}
return false;
}

}
''';

void main() {
  /* TODO
  LibraryElement libElement;

  setUp(() async {
    if (libElement == null) {
      libElement = await _getTestLibElement();
    }
  });

  test('Empty api annotation without param', () async {
    String className = 'ApiWithoutParam';
    Element element = await _getClassForCodeString(className);
    Api api_annotation = _getInstantiatedAnnotation(libElement, className);
    String generateResult = await _generator.generateForAnnotatedElement(
        element, api_annotation, null);

    expect(api_annotation.path, isEmpty);
    expect(generateResult, getCodeForEmptyApi(r'_$Jaguar' + className));
  });

  test('Empty api annotation with name', () async {
    String className = 'ApiWithName';
    Element element = await _getClassForCodeString(className);
    Api api_annotation = _getInstantiatedAnnotation(libElement, className);
    String generateResult = await _generator.generateForAnnotatedElement(
        element, api_annotation, null);

    expect(api_annotation.path, "api");
    expect(generateResult, getCodeForEmptyApi(r'_$Jaguar' + className));
  });

  test('Empty api annotation with version', () async {
    String className = 'ApiWithVersion';
    Element element = await _getClassForCodeString(className);
    Api api_annotation = _getInstantiatedAnnotation(libElement, className);
    String generateResult = await _generator.generateForAnnotatedElement(
        element, api_annotation, null);

    expect(api_annotation.path, isEmpty);
    expect(generateResult, getCodeForEmptyApi(r'_$Jaguar' + className));
  });

  test('Empty api annotation with name and version', () async {
    String className = 'ApiWithNameAndVersion';
    Element element = await _getClassForCodeString(className);
    Api api_annotation = _getInstantiatedAnnotation(libElement, className);
    String generateResult = await _generator.generateForAnnotatedElement(
        element, api_annotation, null);

    expect(api_annotation.path, "api");
    expect(generateResult, getCodeForEmptyApi(r'_$Jaguar' + className));
  });

  group('route', () {
    test('Api annotation with no param and easy route', () async {
      String className = 'ApiWithoutParamWithSimpleRoute';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiWithoutParamWithSimpleRoute);
    });

    test('Api annotation with no param and easy route and with HttpRequest',
        () async {
      String className = 'ApiWithoutParamWithSimpleRouteWithHttpRequest';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult,
          codeForApiWithoutParamWithSimpleRouteAndWithHttpRequest);
    });

    test('Api annotation with no param and future route', () async {
      String className = 'ApiWithoutParamWithFutureRoute';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiWithoutParamWithFutureRoute);
    });

    test('Api annotation with no param and future route and with HttpRequest',
        () async {
      String className = 'ApiWithoutParamWithFutureRouteWithHttpRequest';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(
          generateResult, codeForApiWithoutParamWithFutureRouteWithHttpRequest);
    });

    test('Api annotation with name and simple route', () async {
      String className = 'ApiWithNameWithSimpleRoute';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiWithNameWithSimpleRoute);
    });

    test('Api annotation with name and version and simple route', () async {
      String className = 'ApiWithNameAndVersionWithSimpleRoute';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiWithNameAndVersionWithSimpleRoute);
    });

    test('Api annotation with no param and route with url param', () async {
      String className = 'ApiAndRouteWithParam';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiAndRouteWithParam);
    });

    test(
        'Api annotation with no param and route with HttpRequest and url param',
        () async {
      String className = 'ApiAndRouteWithHttpRequestAndParam';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiAndRouteWithHttpRequestAndParam);
    });

    test('Api annotation with no param and route with query parameter',
        () async {
      String className = 'ApiAndRouteWithQueryParameter';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiAndRouteWithQueryParameter);
    });
  });

  group('group', () {
    test('test empty group', () async {
      String className = 'ApiWithGroup';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiWithGroup);
    });

    test('with simple route', () async {
      String className = 'ApiWithGroupWithSimpleRoute';
      Element element = await _getClassForCodeString(className);
      Api api_annotation = _getInstantiatedAnnotation(libElement, className);
      String generateResult = await _generator.generateForAnnotatedElement(
          element, api_annotation, null);

      expect(generateResult, codeForApiWithGroupWithSimpleRoute);
    });
  });
  */
}
