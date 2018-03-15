part of test.exception.exception;

class CustomException {
  final int code;

  final String message;

  CustomException(this.code, this.message);
}

class CustomExceptionHandler extends ExceptionHandler {
  const CustomExceptionHandler();

  Future<Response<String>> onRouteException(
      Context ctx, e, StackTrace trace) async {
    if (e is CustomException) {
      final String value = '{"Code": ${e.code}, "Message": "${e.message} }';
      return new Response<String>(value, statusCode: 400);
    }
    return null;
  }
}
