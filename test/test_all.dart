library jaguar.test_all;

import 'exception/exception.dart' as exceptionExcept;

import 'jaguar/route/route.dart' as route;
import 'jaguar/include_api/main.dart' as includeApi;
import 'jaguar/query_params/query_params.dart' as queryParams;
import 'jaguar/settings/settings.dart' as settings;
import 'jaguar/interceptor/custom_interceptor/custom_interceptor.dart'
    as customInterceptor;
import 'jaguar/interceptor/inject_request/inject_request.dart' as injectRequest;

import 'decode_body/json/json.dart' as decodeJson;

import 'response/stream/stream.dart' as responseStream;
import 'response/json/json.dart' as responseJson;

//TODO import 'jaguar/websocket/websocket.dart' as websocket;

void main() {
  exceptionExcept.main();

  route.main();
  includeApi.main();
  queryParams.main();
  settings.main();
//  TODO websocket.main();

  customInterceptor.main();
  injectRequest.main();

  decodeJson.main();

  responseStream.main();
  responseJson.main();
}
