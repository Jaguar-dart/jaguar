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

  final String path;

  final List<String> methods;

  final Map<String, String> pathRegEx;

  final int statusCode;

  final String mimeType;

  final String charset;

  final String responseProcessor;

  RouteModel(this.name, this.returnType,
      {this.path,
      this.methods,
      this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.responseProcessor});
}

class GroupModel {
  final String path;

  final String type;

  final String name;

  GroupModel({this.path, this.type, this.name});
}
