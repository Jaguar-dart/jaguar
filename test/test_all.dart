library jaguar.test_all;

import 'jaguar/route/route.dart' as route;
import 'jaguar/group/main.dart' as groupNormal;
import 'jaguar/query_params/query_params.dart' as queryParams;
import 'jaguar/websocket/websocket.dart' as websocket;
import 'jaguar/settings/settings.dart' as settings;
import 'interceptor/param/param.dart' as interceptorParam;
import 'exception/exception.dart' as exceptionExcept;
import 'response/stream/stream.dart' as responseStream;

void main() {
  route.main();
  groupNormal.main();
  queryParams.main();
  settings.main();
  websocket.main();
  interceptorParam.main();
  exceptionExcept.main();
  responseStream.main();
}
