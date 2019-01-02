library jaguar_generator.models;

part 'route.dart';

class ControllerModel {
  final String name;

  String prefix;

  final routes = <RouteModel>[];

  final groups = <GroupModel>[];

  ControllerModel(this.name);
}

class RouteModel {
  final String name;

  final String returnType;

  final String infoSource;

  final String path;

  final List<String> methods;

  final Map<String, String> pathRegEx;

  final int statusCode;

  final String mimeType;

  final String charset;

  RouteModel(this.name, this.returnType, this.infoSource,
      {this.path,
      this.methods,
      this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset});
}

class GroupModel {
  final String path;

  final String type;

  final String name;

  GroupModel(
    this.name,
    this.type, {
    this.path,
  });
}
