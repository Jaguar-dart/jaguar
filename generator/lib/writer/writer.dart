library jaguar_generator.writer;

import 'package:jaguar_generator/models/models.dart';

class Writer {
  ControllerModel _u;

  Writer(this._u);

  List<RouteModel> get _r => _u.routes;

  List<GroupModel> get _g => _u.groups;

  final sb = StringBuffer();

  String generate() {
    sb.writeln("abstract class _\$${_u.name} implements Controller {");

    _r.forEach(_writeRouteSig);
    _g.forEach(_writeIncludeSig);

    sb.writeln("void install(GroupBuilder parent) {");
    sb.writeln("final grp = parent.group(");
    if (_u.prefix != null && _u.prefix.isNotEmpty) {
      sb.writeln("path: ${_u.prefix}");
    }
    sb.write(");");
    _r.forEach(_writeRoute);
    _g.forEach(_writeInclude);
    sb.writeln("}");
    sb.writeln('}');

    return sb.toString();
  }

  void _writeRouteSig(RouteModel r) {
    sb.writeln("${r.returnType} ${r.name}(Context ctx);");
  }

  void _writeRoute(RouteModel r) {
    sb.write("grp.addRoute(Route.fromInfo(");
    sb.write(r.infoSource);
    sb.writeln(", ${r.name}))..before(before);");
  }

  /*
  void _writeRouteInfo(RouteModel r) {
    sb.write("HttpMethod(");

    sb.write("methods: [");
    for (String method in r.methods) sb.write("'$method',");
    sb.write("],");

    if (r.path != null && r.path.isNotEmpty) sb.write("path: '${r.path}',");
    if (r.pathRegEx != null && r.pathRegEx.isNotEmpty) {
      sb.write("pathRegEx: {");
      for (String path in r.pathRegEx.keys)
        sb.write("'$path': r'${r.pathRegEx[path]}',");
      sb.write("},");
    }

    if (r.statusCode != null) sb.write("statusCode: ${r.statusCode},");
    if (r.mimeType != null) sb.write("mimeType: '${r.mimeType}',");
    if (r.charset != null) sb.write("charset: '${r.charset}',");

    sb.write(")");
  }
  */

  void _writeIncludeSig(GroupModel g) {
    sb.writeln("${g.type} get ${g.name};");
  }

  void _writeInclude(GroupModel g) {
    sb.write("${g.name}.install(grp.group(");
    if (g.path != null && g.path.isNotEmpty) {
      sb.write("path: '${g.path}'");
    }
    sb.writeln("));");
  }
}
