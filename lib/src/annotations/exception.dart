part of jaguar.src.annotations;

typedef dynamic ExceptionHandlerFunc(
    HttpRequest request, dynamic e, StackTrace trace);

abstract class ExceptionHandler<ExceptionType> {
  dynamic onRouteException(
      HttpRequest request, ExceptionType e, StackTrace trace);
}
