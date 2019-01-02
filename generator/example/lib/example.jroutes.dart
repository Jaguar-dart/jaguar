// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

abstract class _$SimpleApi implements Controller {
  String get(Context ctx);
  void install(GroupBuilder parent) {
    final grp = parent.group();
    grp.addRoute(Route.fromInfo(
        HttpMethod(
          methods: [
            'GET',
          ],
          path: '',
          statusCode: 200,
          charset: 'utf-8',
        ),
        get))
      ..before(before);
  }
}
