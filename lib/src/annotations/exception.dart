part of jaguar.src.annotations;

/// Exception handler class that handles exception in route chain
abstract class ExceptionHandler<ExceptionType> {
  const ExceptionHandler();

  /// Method that is called when there is an exception in route chain
  FutureOr<Response> onRouteException(
      Context ctx, ExceptionType e, StackTrace trace);

  Type exceptionType() => ExceptionType;
}
