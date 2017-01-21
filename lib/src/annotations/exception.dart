part of jaguar.src.annotations;

typedef dynamic ExceptionHandlerFunc(
    HttpRequest request, dynamic e, StackTrace trace);

abstract class ExceptionHandler<ExceptionType> {
  Future<Response> onRouteException(
      Request request, ExceptionType e, StackTrace trace);
}
