import 'package:source_gen/source_gen.dart';
import 'package:jaguar/jaguar.dart';

final isResponse = new TypeChecker.fromRuntime(Response);

final isContext = new TypeChecker.fromRuntime(Context);

final isRequest = new TypeChecker.fromRuntime(Request);

final isInterceptor = new TypeChecker.fromRuntime(Interceptor);

final isExceptionHandler = new TypeChecker.fromRuntime(ExceptionHandler);

final isIncludeApi = new TypeChecker.fromRuntime(IncludeApi);

final isWrap = new TypeChecker.fromRuntime(Wrap);

final isWrapOne = new TypeChecker.fromRuntime(WrapOne);

final isRouteBase = new TypeChecker.fromRuntime(RouteBase);
