part of jaguar.src.annotations;

abstract class ExceptionHandler<ExceptionType> {
  const ExceptionHandler();

  Future<Response> onRouteException(
      Request request, ExceptionType e, StackTrace trace);

  Type exceptionType() => ExceptionType;
}
