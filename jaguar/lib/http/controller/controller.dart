import 'dart:async';
import '../context/context.dart';

/// Base class for Jaguar controllers
abstract class Controller {
  const Controller();

  /// Called before a route handler is invoked
  FutureOr<void> before(Context ctx) => null;
}
