library jaguar_generator.models;

part 'route.dart';
part 'exception.dart';
part 'package:jaguar_generator/models/interceptor.dart';

class Upper {
  String get name => 'Jaguar$baseName';

  String baseName;

  String prefix;

  final List<Route> routes = [];

  final List<Group> groups = [];

  final Map<String, bool> interceptorMethods = {};
}
