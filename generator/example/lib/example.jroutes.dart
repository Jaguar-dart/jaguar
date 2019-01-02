// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

abstract class _$SimpleApi implements Controller {
  String get(Context ctx);
  IncludeApi get include;
  void install(GroupBuilder parent) {
    final grp = parent.group();
    grp.addRoute(Route.fromInfo(Get(), get))..before(before);
    include.install(grp.group(path: '/include'));
  }
}

abstract class _$IncludeApi implements Controller {
  Future<List<int>> upIt(Context ctx);
  void install(GroupBuilder parent) {
    final grp = parent.group();
    grp.addRoute(Route.fromInfo(
        HttpMethod(
            methods: const ['UP'],
            statusCode: 201,
            responseProcessor: jsonResponseProcessor),
        upIt))
      ..before(before);
  }
}
