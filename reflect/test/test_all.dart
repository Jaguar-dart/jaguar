import 'bind/bind.dart' as bindTests;
import 'include/include.dart' as includeTests;
import 'interceptor/after.dart' as interceptorAfterTests;
import 'interceptor/before.dart' as interceptorBeforeTests;
import 'interceptor/exception.dart' as interceptorExceptionTests;
import 'routes/route.dart' as routesTests;

main() {
  bindTests.main();

  includeTests.main();

  interceptorAfterTests.main();
  interceptorBeforeTests.main();
  interceptorExceptionTests.main();

  routesTests.main();
}
