library jaguar.test_all;

import 'jaguar/route/route.dart' as route;
import 'jaguar/group/main.dart' as groupNormal;
import 'jaguar/query_params/query_params.dart' as queryParams;
import 'jaguar/websocket/websocket.dart' as websocket;
import 'jaguar/settings/settings.dart' as settings;
import 'exception/exception.dart' as exceptionExcept;
import 'response/stream/stream.dart' as responseStream;
import 'jaguar/interceptor/custom_interceptor/custom_interceptor.dart'
    as customInterceptor;
import 'jaguar/interceptor/use_interceptor/use_interceptor.dart'
    as useInterceptor;
import 'jaguar/interceptor/inject_request/inject_request.dart' as injectRequest;
import 'jaguar/interceptor/wrapper_creator/wrapper_creator.dart'
    as wrapperCreator;

void main() {
  route.main();
  groupNormal.main();
  queryParams.main();
  settings.main();
  websocket.main();
  exceptionExcept.main();
  responseStream.main();

  customInterceptor.main();
  useInterceptor.main();
  injectRequest.main();
  wrapperCreator.main();
}
