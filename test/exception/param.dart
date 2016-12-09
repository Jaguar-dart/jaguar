part of test.exception.exception;

class User {
  String name;

  int age;

  User(this.name, this.age);
}

class ValidationException {
  final String field;

  final String message;

  ValidationException(this.field, this.message);
}

class ValidationExceptionHandler
    implements ExceptionHandler<ValidationException> {
  const ValidationExceptionHandler();

  void onRouteException(
      HttpRequest request, ValidationException e, StackTrace trace) {
    request.response.statusCode = 400;

    request.response.write('{"Field": ${e.field}, "Message": "${e.message} }');
  }
}

class WrapUserParser implements RouteWrapper<UserParser> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapUserParser({this.id});

  UserParser createInterceptor() => new UserParser();
}

class UserParser extends Interceptor {
  UserParser();

  @InputQueryParams()
  User pre(QueryParams queryParams) {
    if (queryParams.name is! String) {
      throw new ValidationException('name', 'is required!');
    } else {
      String value = queryParams.name;

      if (value.isEmpty) {
        throw new ValidationException('name', 'Cannot be empty!');
      }
    }

    if (queryParams.age is! String) {
      throw new ValidationException('age', 'Is required!');
    } else {
      int value = queryParams.age;

      if (value <= 0) {
        throw new ValidationException('age', 'Must be positive!');
      }
    }

    return new User(queryParams.name, queryParams.age);
  }
}
