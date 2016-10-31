part of jaguar.generator.writer;

class RouteCallWriter {
  final RouteInfo route;

  RouteCallWriter(this.route);

  String _generatePathParamInjector() {
    StringBuffer sb = new StringBuffer();

    if (route.needsPathParamInjection) {
      //TODO what if it is dynamic?
      sb.write(route.pathParamInjectionParam.type.name);
      sb.write(" injectPathParam = new ");
      sb.writeln(route.pathParamInjectionParam.type.name +
          '.FromPathParam(pathParams);');

      if (route.route.validatePathParams) {
        sb.writeln(
            'if(injectPathParam is Validatable) {injectPathParam.validate();}');
      }
    }

    return sb.toString();
  }

  String _generateQueryParamInjector() {
    StringBuffer sb = new StringBuffer();

    if (route.needsQueryParamInjection) {
      //TODO what if it is dynamic?
      sb.write(route.queryParamInjectionParam.type.name);
      sb.write(" injectQueryParam = new ");
      sb.write(route.pathParamInjectionParam.type.name +
          '.FromQueryParam(pathParams);');

      if (route.route.validateQueryParams) {
        sb.writeln(
            'if(injectQueryParam is Validatable) {injectQueryParam.validate();}');
      }
    }

    return sb.toString();
  }

  String generate() {
    StringBuffer sb = new StringBuffer();

    sb.write(_generatePathParamInjector());

    sb.write(_generateQueryParamInjector());

    if (!route.returnsVoid) {
      if (!route.returnsFuture) {
        sb.write("rRouteResponse = ");
      } else {
        sb.write("rRouteResponse = await ");
      }
    }

    sb.write(route.name + "(");

    if (route.needsHttpRequest) {
      sb.write("request, ");
    }

    if (route.inputs.length != 0) {
      final String params =
          route.inputs.map((InputInfo info) => info.genName).join(", ");
      sb.write(params);
      sb.write(',');
    }

    if (route.nonInputParams.length > 0) {
      final String paramsStr = route.nonInputParams
          .map((ParameterElement param) => new ParameterElementWrap(param))
          .map((ParameterElementWrap param) {
        if (!param.type.isBuiltin) {
          if (param.name == 'pathParams') {
            return 'injectPathParam';
          } else if (param.name == 'queryParams') {
            return 'injectQueryParam';
          }
          return 'null';
        }
        String build = _getStringTo(param);
        build += "(pathParams.getField('${param.name}'))";
        return build;
      }).join(", ");

      sb.write(paramsStr);
      sb.write(',');
    }

    if (route.optionalParams.length > 0) {
      if (route.areOptionalParamsPositional) {
        final String params = route.optionalParams
            .map((ParameterElement info) => new ParameterElementWrap(info))
            .map((ParameterElementWrap info) {
          if (!info.type.isBuiltin) {
            return 'null';
          }
          String build = _getStringTo(info);
          build += "(queryParams.getField('${info.name}'))";
          if (info.toValueIfBuiltin != null) {
            build += "??${info.toValueIfBuiltin}";
          }
          return build;
        }).join(", ");
        sb.write(params);
        sb.write(',');
      } else {
        final String params = route.optionalParams
            .where((ParameterElement info) =>
                new DartTypeWrap(info.type).isBuiltin)
            .map((ParameterElement info) => new ParameterElementWrap(info))
            .map((ParameterElementWrap info) {
          String build = "${info.name}: " + _getStringTo(info);
          build += "(queryParams.getField('${info.name}'))";
          if (info.toValueIfBuiltin != null) {
            build += "??${info.toValueIfBuiltin}";
          }
          return build;
        }).join(", ");
        sb.write(params);
        sb.write(',');
      }
    }

    sb.writeln(");");

    return sb.toString();
  }
}
