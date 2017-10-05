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

class ValidationExceptionHandler extends ExceptionHandler<ValidationException> {
  const ValidationExceptionHandler();

  Future<Response<String>> onRouteException(
      Context ctx, ValidationException e, StackTrace trace) async {
    final String value = '{"Field": ${e.field}, "Message": "${e.message} }';
    return new Response<String>(value, statusCode: 400);
  }
}

class UserParser extends Interceptor {
  UserParser();

  User pre(Context ctx) {
    QueryParams queryParams = ctx.queryParams;
    if (queryParams['name'] is! String) {
      throw new ValidationException('name', 'is required!');
    } else {
      String value = queryParams['name'];

      if (value.isEmpty) {
        throw new ValidationException('name', 'Cannot be empty!');
      }
    }

    if (queryParams['age'] is! String) {
      throw new ValidationException('age', 'Is required!');
    } else {
      int value = queryParams['age'];

      if (value <= 0) {
        throw new ValidationException('age', 'Must be positive!');
      }
    }

    return new User(queryParams['name'], queryParams['age']);
  }
}
