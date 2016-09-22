/// [JaguarError] is the basic error in jaguar
class JaguarError extends Error {
  /// define the status code of the request
  final int statusCode;

  /// name the error
  final String name;

  /// a [message] can be defined
  final String message;

  ///  create a [JaguarError] with an optional [message]
  JaguarError(this.statusCode, this.name, this.message);

  @override
  String toString() => message;
}

class NotFoundError extends JaguarError {
  NotFoundError([String message = "Not found."])
      : super(404, "Not found", message);
}

class BadRequestError extends JaguarError {
  BadRequestError([String message = "Bad request."])
      : super(400, "Bad request", message);
}

class ConflictError extends JaguarError {
  ConflictError([String message = "Conflict."])
      : super(409, "Conflict", message);
}

class UnAuthorizedError extends JaguarError {
  UnAuthorizedError([String message = "UnAuthorized."])
      : super(401, "UnAuthorized", message);
}
