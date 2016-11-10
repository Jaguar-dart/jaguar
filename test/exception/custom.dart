part of test.exception.exception;

class CustomException {
  final int code;

  final String message;

  CustomException(this.code, this.message);
}

class CustomExceptionHandler implements ExceptionHandler<CustomException> {
  const CustomExceptionHandler();

  void onRouteException(
      HttpRequest request, CustomException e, StackTrace trace) {
    request.response.statusCode = 400;

    request.response.write('{"Code": ${e.code}, "Message": "${e.message} }');
  }
}
