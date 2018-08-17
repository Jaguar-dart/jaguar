import 'dart:io';
import 'package:jaguar/jaguar.dart';

class UnauthorizedException implements ExceptionWithResponse {
  final String message;
  const UnauthorizedException(this.message);

  @override
  Response get response =>
      Response(message, statusCode: HttpStatus.unauthorized);

  static const invalidRequest = UnauthorizedException("Invalid request!");
  static const notLoggedIn = UnauthorizedException("Please login!");
  static const subjectNotFound = UnauthorizedException("Subject not found!");
  static const invalidPassword = UnauthorizedException("Invalid password!");
}
