part of jaguar.src.annotations;

abstract class ExceptionHandler<ExceptionType> {
  const ExceptionHandler();

  FutureOr<Response> onRouteException(
      Request request, ExceptionType e, StackTrace trace);

  Type exceptionType() => ExceptionType;
}
