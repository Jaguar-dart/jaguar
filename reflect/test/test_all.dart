import 'include/include_test.dart' as includeTests;
import 'interceptor/after_test.dart' as interceptorAfterTests;
import 'interceptor/before_test.dart' as interceptorBeforeTests;
import 'interceptor/exception_test.dart' as interceptorExceptionTests;
import 'routes/route_test.dart' as routesTests;

main() {
  includeTests.main();

  interceptorAfterTests.main();
  interceptorBeforeTests.main();
  interceptorExceptionTests.main();

  routesTests.main();
}
