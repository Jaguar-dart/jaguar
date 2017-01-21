part of test.exception.exception;

class CustomException {
  final int code;

  final String message;

  CustomException(this.code, this.message);
}

class CustomExceptionHandler implements ExceptionHandler<CustomException> {
  const CustomExceptionHandler();

  Future<Response<String>> onRouteException(
      Request request, CustomException e, StackTrace trace) async {
    final String value = '{"Code": ${e.code}, "Message": "${e.message} }';
    return new Response<String>(value, statusCode: 400);
  }
}
