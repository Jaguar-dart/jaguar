part of jaguar.generator.writer;

class InterceptorClassPostWriter {
  final RouteInfo route;

  final InterceptorClassInfo info;

  InterceptorClassPostWriter(this.route, this.info);

  String generate() {
    StringBuffer sb = new StringBuffer();

    if (!info.dual.post.returnsVoid) {
      if (info.dual.post.returnsFuture) {
        sb.write("await ");
      }
    }

    sb.write(info.genInstanceName);
    sb.write(".post(");

    if (info.dual.post.needsHttpRequest) {
      sb.write("request, ");
    }

    if (info.dual.post.inputs.length != 0) {
      final String params = info.dual.post.inputs.map((Input inp) {
        if (inp is InputInterceptor) {
          if (route.returnsResponse && inp.isRouteResponse) {
            return inp.genName + '.value';
          } else {
            return inp.genName;
          }
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

    if (info.dual.post.nonInputParams.length > 0) {
      final String paramsStr = info.dual.post.nonInputParams
          .map((ParameterElement param) => new ParameterElementWrap(param))
          .map((ParameterElementWrap param) {
        if (param.name == 'pathParams') {
          return 'pathParams';
        } else if (param.name == 'queryParams') {
          return 'queryParams';
        }
        return 'null';
      }).join(',');

      sb.write(paramsStr);
      sb.write(',');
    }

    sb.writeln(");");

    return sb.toString();
  }
}
