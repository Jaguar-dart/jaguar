import 'dart:async';
import '../context/context.dart';

/// [Controller] defines the interface all Jaguar controllers must implement.
///
/// [before] method is called before any route handler belonging to the controller
/// is called.
///
/// Use [GenController] annotation to tell Jaguar that your controller class
/// is a controller.
///
/// Implement route handlers as methods in your controller class and annotate them
/// with one of the [HttpMethod] annotations.
///
///
///     import 'dart:async';
///     import 'package:jaguar/jaguar.dart';
///     import 'package:jaguar_reflect/jaguar_reflect.dart';
///     @GenController(path: '/library')
///     class LibraryApi extends Controller {
///       @Get(path: '/all')
///       Future<List<Book>> getAll(Context ctx) => books;
///
///       @Post(path: '/add')
///       Future<void> add(Context ctx) {
///         // TODO
///       }
///     }
///
///     main(List<String> args) async {
///       final server = Jaguar(port: 10000);
///       server.add(reflect(LibraryApi()));
///       await server.serve();
///     }
abstract class Controller {
  const Controller();

  /// Called before a route handler is invoked
  FutureOr<void> before(Context ctx) => null;
}
