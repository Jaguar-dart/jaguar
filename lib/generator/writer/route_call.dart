part of jaguar.generator.writer;

class RouteCallWriter {
  final RouteInfo route;

  RouteCallWriter(this.route);

  String _generatePathParamInjector() {
    StringBuffer sb = new StringBuffer();

    if (route.needsPathParamInjection) {
      if (!route.pathParamInjectionParam.type.isDynamic) {
        sb.write(route.pathParamInjectionParam.type.name);
        sb.write(" injectPathParam = new ");
        sb.writeln(route.pathParamInjectionParam.type.name +
            '.FromPathParam(pathParams);');
      } else {
        sb.writeln('final injectPathParam = pathParams;');
      }

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
      if (!route.queryParamInjectionParam.type.isDynamic) {
        sb.write(route.queryParamInjectionParam.type.name);
        sb.write(" injectQueryParam = new ");
        sb.write(route.pathParamInjectionParam.type.name +
            '.FromQueryParam(queryParams);');
      } else {
        sb.writeln('final injectQueryParam = queryParams;');
      }

      if (route.route.validateQueryParams) {
        sb.writeln(
            'if(injectQueryParam is Validatable) {injectQueryParam.validate();}');
      }
    }

    return sb.toString();
  }

  String generate() {
    StringBuffer sb = new StringBuffer();

    if (route.isWebSocket) {
      sb.write("WebSocket ws = await WebSocketTransformer.upgrade(request);");
    }

    sb.write(_generatePathParamInjector());

    sb.write(_generateQueryParamInjector());

    if (!route.isWebSocket) {
      if (!route.returnsVoid) {
        sb.write("rRouteResponse = ");
      }
    }

    if (!route.returnsVoid) {
      if (route.returnsFuture) {
        sb.write("await ");
      }
    }

    if (route.groupNames.length > 0) {
      sb.write(route.groupNames.join('.'));
      sb.write('.');
    }

    sb.write(route.name + "(");

    if (route.needsHttpRequest) {
      sb.write("request, ");
    }

    if (route.isWebSocket) {
      sb.write("ws, ");
    }

    if (route.inputs.length != 0) {
      final String params = route.inputs.map((Input inp) {
        if (inp is InputInterceptor) {
          return inp.genName;
        } else if (inp is InputCookie) {
          return "request.cookies.firstWhere((cookie) => cookie.name == '${inp.key}', orElse: () => null)?.value";
        } else if (inp is InputCookies) {
          return 'request.cookies';
        } else if (inp is InputHeader) {
          return "request.headers.value('${inp.key}')";
        } else if (inp is InputHeaders) {
          return 'request.headers';
        }
      }).join(", ");
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
